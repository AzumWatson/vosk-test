<script lang="ts">
	import { onMount } from 'svelte';
	import { createModel, type KaldiRecognizer, type Model } from 'vosk-browser';
	import { base } from '$app/paths';
	
	let isRecording = false;
	let isLoading = true;
	let transcript = '';
	let partialTranscript = '';
	let error = '';
	
	let model: Model | null = null;
	let recognizer: KaldiRecognizer | null = null;
	let audioContext: AudioContext | null = null;
	let mediaStream: MediaStream | null = null;
	let audioWorkletNode: AudioWorkletNode | null = null;
	
	// 初始化模型
	onMount(async () => {
		try {
			// 创建 Vosk 模型 - 从本地加载
			// 模型文件需要放在 static/models/ 目录下
			model = await createModel(`${base}/models/vosk-model-small-cn-0.22.zip`);
			
			recognizer = new model.KaldiRecognizer(16000);
			recognizer.setWords(true);
			
			// 监听识别结果
			recognizer.on('result', (message: any) => {
				const result = message.result;
				if (result.text) {
					transcript += result.text + '\n';
					partialTranscript = '';
				}
			});
			
			recognizer.on('partialresult', (message: any) => {
				partialTranscript = message.result.partial;
			});
			
			isLoading = false;
		} catch (err) {
			error = '模型加载失败: ' + (err as Error).message;
			isLoading = false;
		}
	});
	
	async function startRecording() {
		try {
			if (!recognizer) {
				error = '识别器未初始化';
				return;
			}
			
			// 检查麦克风权限
			if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
				error = '浏览器不支持麦克风访问，请使用 Chrome/Firefox/Safari 等现代浏览器';
				return;
			}
			
			// 获取麦克风权限 - 使用更宽松的参数
			mediaStream = await navigator.mediaDevices.getUserMedia({
				audio: {
					echoCancellation: true,
					noiseSuppression: true,
					autoGainControl: true
				}
			});
			
			// 创建音频上下文 - 不强制 16kHz，使用默认采样率
			audioContext = new AudioContext();
			const source = audioContext.createMediaStreamSource(mediaStream);
			
			// 如果采样率不是 16kHz，创建重采样器
			if (audioContext.sampleRate !== 16000) {
				console.log(`音频采样率: ${audioContext.sampleRate}Hz，将重采样到 16000Hz`);
			}
			
			// 创建音频处理节点
			await audioContext.audioWorklet.addModule(`${base}/audio-processor.js`);
			audioWorkletNode = new AudioWorkletNode(audioContext, 'audio-processor', {
				processorOptions: {
					targetSampleRate: 16000,
					sourceSampleRate: audioContext.sampleRate
				}
			});
			
			// 连接音频流
			source.connect(audioWorkletNode);
			// 不连接到 destination，避免回声
			// audioWorkletNode.connect(audioContext.destination);
			
			// 处理音频数据
			audioWorkletNode.port.onmessage = (event) => {
				if (recognizer) {
					recognizer.acceptWaveform(event.data);
				}
			};
			
			isRecording = true;
			error = '';
		} catch (err) {
			const errorMsg = (err as Error).message;
			
			// 提供更友好的错误提示
			if (errorMsg.includes('not found') || errorMsg.includes('NotFoundError')) {
				error = '未找到麦克风设备。请检查：\n1. 电脑是否有麦克风\n2. 麦克风是否被其他应用占用\n3. 浏览器是否有麦克风权限';
			} else if (errorMsg.includes('Permission') || errorMsg.includes('NotAllowedError')) {
				error = '麦克风权限被拒绝。请在浏览器设置中允许此网站访问麦克风';
			} else if (errorMsg.includes('NotReadable')) {
				error = '无法读取麦克风。麦克风可能正被其他应用使用';
			} else {
				error = '录音启动失败: ' + errorMsg;
			}
		}
	}
	
	async function stopRecording() {
		if (audioWorkletNode) {
			audioWorkletNode.disconnect();
			audioWorkletNode = null;
		}
		
		if (audioContext) {
			await audioContext.close();
			audioContext = null;
		}
		
		if (mediaStream) {
			mediaStream.getTracks().forEach(track => track.stop());
			mediaStream = null;
		}
		
		if (recognizer) {
			const finalResult = recognizer.finalResult() as any;
			if (finalResult && finalResult.text) {
				transcript += finalResult.text + '\n';
			}
		}
		
		isRecording = false;
		partialTranscript = '';
	}
	
	function clearTranscript() {
		transcript = '';
		partialTranscript = '';
	}
	
	// 测试麦克风
	async function testMicrophone() {
		try {
			const devices = await navigator.mediaDevices.enumerateDevices();
			const audioInputs = devices.filter(device => device.kind === 'audioinput');
			
			if (audioInputs.length === 0) {
				alert('❌ 未找到麦克风设备\n\n请检查：\n1. 是否连接了麦克风\n2. 麦克风是否在系统设置中启用');
			} else {
				const deviceList = audioInputs.map((d, i) => `${i + 1}. ${d.label || '麦克风 ' + (i + 1)}`).join('\n');
				alert(`✅ 找到 ${audioInputs.length} 个麦克风设备：\n\n${deviceList}\n\n可以点击"开始录音"按钮使用`);
			}
		} catch (err) {
			alert('❌ 无法检测麦克风：' + (err as Error).message);
		}
	}
</script>

<div class="container">
	<h1>🎤 离线语音记录</h1>
	
	{#if isLoading}
		<div class="loading">
			<p>正在加载语音识别模型...</p>
			<p class="note">模型从本地加载，确保已下载到 static/models/ 目录</p>
		</div>
	{:else if error}
		<div class="error">
			<p>❌ {error}</p>
			<p class="error-hint">
				如果提示模型加载失败，请检查：<br/>
				1. 确认已下载模型文件到 static/models/ 目录<br/>
				2. 文件名为: vosk-model-small-cn-0.22.zip<br/>
				3. 查看 static/models/README.md 了解下载方法
			</p>
		</div>
	{:else}
		<div class="controls">
			{#if !isRecording}
				<button class="btn btn-start" on:click={startRecording}>
					🎤 开始录音
				</button>
				<button class="btn btn-test" on:click={testMicrophone}>
					🔍 测试麦克风
				</button>
			{:else}
				<button class="btn btn-stop" on:click={stopRecording}>
					⏹️ 停止录音
				</button>
			{/if}
			
			<button class="btn btn-clear" on:click={clearTranscript} disabled={!transcript && !partialTranscript}>
				🗑️ 清空文本
			</button>
		</div>
		
		{#if isRecording}
			<div class="status recording">
				● 正在录音中...
			</div>
		{/if}
		
		<div class="transcript-container">
			<h2>识别结果：</h2>
			<div class="transcript">
				{#if transcript}
					<p class="final">{transcript}</p>
				{/if}
				{#if partialTranscript}
					<p class="partial">{partialTranscript}</p>
				{/if}
				{#if !transcript && !partialTranscript}
					<p class="placeholder">点击"开始录音"后，说话内容会在这里显示...</p>
				{/if}
			</div>
		</div>
	{/if}
	
	<div class="info">
		<h3>使用说明：</h3>
		<ul>
			<li>✅ 完全离线运行，无需网络连接</li>
			<li>🇨🇳 支持中文语音识别（Vosk 小型模型）</li>
			<li>🔒 隐私安全，数据不离开浏览器</li>
			<li>💾 模型文件从本地加载（static/models/）</li>
			<li>🎯 支持实时转写和最终结果</li>
		</ul>
	</div>
</div>

<style>
	:global(body) {
		margin: 0;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		min-height: 100vh;
	}
	
	.container {
		max-width: 800px;
		margin: 0 auto;
		padding: 2rem;
		color: white;
	}
	
	h1 {
		text-align: center;
		font-size: 2.5rem;
		margin-bottom: 2rem;
		text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
	}
	
	.loading, .error {
		background: rgba(255, 255, 255, 0.15);
		backdrop-filter: blur(10px);
		border-radius: 12px;
		padding: 2rem;
		text-align: center;
		margin: 2rem 0;
	}
	
	.loading p {
		font-size: 1.2rem;
		margin: 0.5rem 0;
	}
	
	.note {
		font-size: 0.9rem;
		opacity: 0.8;
	}
	
	.error {
		background: rgba(255, 59, 48, 0.3);
		border: 2px solid rgba(255, 59, 48, 0.5);
	}
	
	.error-hint {
		margin-top: 1rem;
		font-size: 0.9rem;
		text-align: left;
		line-height: 1.6;
		opacity: 0.9;
	}
	
	.controls {
		display: flex;
		gap: 1rem;
		justify-content: center;
		margin: 2rem 0;
		flex-wrap: wrap;
	}
	
	.btn {
		padding: 1rem 2rem;
		font-size: 1.1rem;
		font-weight: bold;
		border: none;
		border-radius: 8px;
		cursor: pointer;
		transition: all 0.3s ease;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
	}
	
	.btn:hover:not(:disabled) {
		transform: translateY(-2px);
		box-shadow: 0 6px 8px rgba(0, 0, 0, 0.3);
	}
	
	.btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
	
	.btn-start {
		background: #34c759;
		color: white;
	}
	
	.btn-stop {
		background: #ff3b30;
		color: white;
		animation: pulse 1.5s infinite;
	}
	
	@keyframes pulse {
		0%, 100% { opacity: 1; }
		50% { opacity: 0.7; }
	}
	
	.btn-clear {
		background: rgba(255, 255, 255, 0.2);
		color: white;
		backdrop-filter: blur(10px);
	}
	
	.btn-test {
		background: #007aff;
		color: white;
	}
	
	.status {
		text-align: center;
		font-size: 1.2rem;
		margin: 1rem 0;
		font-weight: bold;
	}
	
	.status.recording {
		color: #ff3b30;
		animation: blink 1s infinite;
	}
	
	@keyframes blink {
		0%, 50%, 100% { opacity: 1; }
		25%, 75% { opacity: 0.5; }
	}
	
	.transcript-container {
		background: rgba(255, 255, 255, 0.95);
		border-radius: 12px;
		padding: 2rem;
		margin: 2rem 0;
		box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
	}
	
	h2 {
		color: #333;
		margin-top: 0;
		margin-bottom: 1rem;
	}
	
	.transcript {
		background: #f8f9fa;
		border-radius: 8px;
		padding: 1.5rem;
		min-height: 200px;
		max-height: 400px;
		overflow-y: auto;
		color: #333;
		line-height: 1.8;
		font-size: 1.1rem;
	}
	
	.transcript .final {
		margin: 0;
		white-space: pre-wrap;
		word-wrap: break-word;
	}
	
	.transcript .partial {
		margin: 0;
		color: #007aff;
		font-style: italic;
	}
	
	.transcript .placeholder {
		color: #999;
		text-align: center;
		margin: 4rem 0;
	}
	
	.info {
		background: rgba(255, 255, 255, 0.15);
		backdrop-filter: blur(10px);
		border-radius: 12px;
		padding: 1.5rem;
		margin-top: 2rem;
	}
	
	.info h3 {
		margin-top: 0;
	}
	
	.info ul {
		list-style: none;
		padding: 0;
	}
	
	.info li {
		padding: 0.5rem 0;
		font-size: 1rem;
	}
</style>
