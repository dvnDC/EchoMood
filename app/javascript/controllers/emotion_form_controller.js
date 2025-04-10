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
            return "Radość/Podekscytowanie"
        } else if (valence < 0 && arousal > 0) {
            return "Złość/Lęk"
        } else if (valence < 0 && arousal < 0) {
            return "Smutek/Przygnębienie"
        } else if (valence > 0 && arousal < 0) {
            return "Spokój/Relaks"
        } else {
            return "Neutralnie"
        }
    }
}