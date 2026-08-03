// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void playWebTone({double freq = 880, double duration = 0.5, double volume = 0.3}) {
  js.context.callMethod('eval', ['''
    (function() {
      try {
        var ctx = new (window.AudioContext || window.webkitAudioContext)();
        var osc = ctx.createOscillator();
        var gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.value = $freq;
        gain.gain.value = $volume;
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + $duration);
        osc.stop(ctx.currentTime + $duration);
      } catch(e) {}
    })();
  ''']);
}

void playWebChord(List<double> freqs, {double duration = 0.8}) {
  final freqsJs = freqs.join(',');
  js.context.callMethod('eval', ['''
    (function() {
      try {
        var ctx = new (window.AudioContext || window.webkitAudioContext)();
        var gain = ctx.createGain();
        gain.gain.value = 0.18;
        gain.connect(ctx.destination);
        [$freqsJs].forEach(function(f) {
          var osc = ctx.createOscillator();
          osc.type = 'sine';
          osc.frequency.value = f;
          osc.connect(gain);
          osc.start();
          osc.stop(ctx.currentTime + $duration);
        });
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + $duration);
      } catch(e) {}
    })();
  ''']);
}
