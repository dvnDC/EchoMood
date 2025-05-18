import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["valenceSlider", "arousalSlider", "valenceValue", "arousalValue", "emotionMarker", "predictedEmotion"]

    connect() {
        console.log("Emotion form controller connected")
        this.updateEmotionDisplay()
    }

    updateEmotionDisplay() {
        const valence = parseInt(this.valenceSliderTarget.value)
        const arousal = parseInt(this.arousalSliderTarget.value)

        this.valenceValueTarget.textContent = valence
        this.arousalValueTarget.textContent = arousal

        const markerX = ((valence + 10) / 20) * 100  // Conversion from -10.10 to 0-100%
        const markerY = 100 - ((arousal + 10) / 20) * 100  // Inverted Y-axis for CSS

        this.emotionMarkerTarget.style.left = `${markerX}%`
        this.emotionMarkerTarget.style.top = `${markerY}%`

        this.predictedEmotionTarget.textContent = this.predictEmotion(valence, arousal)
    }

    predictEmotion(valence, arousal) {
        if (valence > 0 && arousal > 0) {
            return "Joy/Excitement"
        } else if (valence < 0 && arousal > 0) {
            return "Anger/Fear"
        } else if (valence < 0 && arousal < 0) {
            return "Sadness/Depression"
        } else if (valence > 0 && arousal < 0) {
            return "Peace/Relaxation"
        } else {
            return "Neutral"
        }
    }
}