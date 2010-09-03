    private function resetPlayer():void {
      if (playing) {
        pause();
      }
      soundChannel = null;
      initLoopSlider();
    }
        
    private function preparePlayer():void {
      resetPlayer();

      outputSound = new Sound();
      soundTouch = new SoundTouch();
      updateFilter();

      filter = new SimpleFilter(sound, soundTouch);

      outputSound.addEventListener(SampleDataEvent.SAMPLE_DATA, filter.handleSampleData);
      
      playButton.enabled = true;
      playButton.label = "Play";
      playing = false;
      this.play();
    }
    
    private function onEnterFrame(e:Event):void {
        if (soundChannel != null) {
            var bytesPosition:int = filter.sourcePosition;
            var position:Number = filter.sourcePosition / FREQUENCY;
            
            //trace("posi : " + filter.sourcePosition);
            //trace("right : " + rightThumbBytes);
            //trace("left : " + leftThumbBytes);
            if (filter.sourcePosition > rightThumbBytes || filter.sourcePosition < leftThumbBytes) {
                filter.sourcePosition = leftThumbBytes;
                position = filter.sourcePosition / FREQUENCY;
                this.pause();
                setTimeout(play, timeAfterLoop);
            }
            
            var newX:int = ((position / soundLength) * timeSlider.width);
            
            // set up times
            var minutes:Number = Math.floor(position / 1000 / 60);
            var seconds:Number = Math.floor(position / 1000) % 60;
            var totalMins:Number = Math.floor(soundLength / 1000 / 60);
            var totalSec:Number = Math.floor(soundLength / 1000) % 60;
           }
        if (playing) {
           updateTime(newX, minutes, seconds, totalMins, totalSec);
        }
    }
    
    private function updateTime(newX:Number, minutes:Number, seconds:Number, totalMins:Number, totalSec:Number):void {
        timeSlider.getThumbAt(0).x = newX;
        songTime.text = ((minutes < 10) ? "0" + minutes : minutes) + ":" + ((seconds < 10) ? "0" + seconds : seconds);
        songTotalTime.text = ((totalMins < 10) ? "0" + totalMins : totalMins) + ":" + ((totalSec < 10) ? "0" + totalSec : totalSec); 
    }
    
    private function togglePlayPause():void {
      if (!playing) {
        play();
      }
      else {
        pause();
      }
    }

    private function play():void {
      soundChannel = outputSound.play();
      soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
      setVolume(volumeSlider.value);
      playing = true;
      playButton.label = "Pause";
    }
 
    private function pause():void {
      if (playing) {
        soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
        this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        soundChannel.stop();
      }
      playing = false;
      playButton.label = "Play";
      
    }
    
    private function setVolume(volume:Number):void {
        if(sound != null){
            trace("setVolume: " + volume);
            var transform:SoundTransform = soundChannel.soundTransform;
            transform.volume = volume;
            soundChannel.soundTransform = transform;
        }else{
            trace("no song to set volume");
            return;
        }
    }
    
    private function doThumbDrag(event:Event):void {
        if(sound == null) return;
        
        var playhead:Number = timeSlider.value;
        filter.sourcePosition = (playhead * soundSizeInBytes) / TIMESLIDERLENGTH;
    }
