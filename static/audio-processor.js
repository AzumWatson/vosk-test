class AudioProcessor extends AudioWorkletProcessor {
	constructor(options) {
		super();
		
		// 获取采样率参数
		const processorOptions = options.processorOptions || {};
		this.targetSampleRate = processorOptions.targetSampleRate || 16000;
		this.sourceSampleRate = processorOptions.sourceSampleRate || sampleRate;
		
		// 计算重采样比率
		this.resampleRatio = this.sourceSampleRate / this.targetSampleRate;
		
		// 缓冲区设置
		this.bufferSize = 512;
		this.buffer = new Float32Array(this.bufferSize);
		this.bufferIndex = 0;
		
		// 重采样相关
		this.inputBuffer = [];
		this.inputBufferIndex = 0;
		
		console.log(`AudioProcessor initialized: ${this.sourceSampleRate}Hz -> ${this.targetSampleRate}Hz (ratio: ${this.resampleRatio.toFixed(2)})`);
	}

	process(inputs, outputs, parameters) {
		const input = inputs[0];
		
		if (input.length > 0) {
			const inputChannel = input[0];
			
			// 添加到输入缓冲区
			for (let i = 0; i < inputChannel.length; i++) {
				this.inputBuffer.push(inputChannel[i]);
			}
			
			// 重采样处理
			while (this.inputBuffer.length >= this.resampleRatio) {
				// 简单的线性插值重采样
				const index = this.inputBufferIndex * this.resampleRatio;
				const indexFloor = Math.floor(index);
				const indexCeil = Math.min(indexFloor + 1, this.inputBuffer.length - 1);
				const fraction = index - indexFloor;
				
				// 线性插值
				const sample = this.inputBuffer[indexFloor] * (1 - fraction) + 
				               this.inputBuffer[indexCeil] * fraction;
				
				this.buffer[this.bufferIndex++] = sample;
				this.inputBufferIndex++;
				
				// 当缓冲区满时，发送数据
				if (this.bufferIndex >= this.bufferSize) {
					// 转换为 16 位整数 PCM
					const pcm16 = new Int16Array(this.bufferSize);
					for (let j = 0; j < this.bufferSize; j++) {
						const s = Math.max(-1, Math.min(1, this.buffer[j]));
						pcm16[j] = s < 0 ? s * 0x8000 : s * 0x7FFF;
					}
					
					this.port.postMessage(pcm16.buffer);
					this.bufferIndex = 0;
				}
				
				// 清理已处理的输入缓冲区
				if (this.inputBufferIndex * this.resampleRatio >= this.inputBuffer.length) {
					this.inputBuffer = [];
					this.inputBufferIndex = 0;
				}
			}
		}
		
		return true;
	}
}

registerProcessor('audio-processor', AudioProcessor);
