import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import QtMultimedia

Item {
	id: soundPage;

	property alias cfg_volume: soundPage.internalVolume
	property double internalVolume: volumeSlider.value / 100

	MediaPlayer {
		id: testSound;
		source: Qt.resolvedUrl("../../effects/meow.mp3");
		audioOutput: AudioOutput {
			volume: volumeSlider.value / 100
		}
	}

	ColumnLayout {
		anchors.left: parent.left
		anchors.right: parent.right

		Kirigami.FormLayout {
			Layout.fillWidth: true

			RowLayout {
				Kirigami.FormData.label: i18n("Volume:")
				Layout.fillWidth: true

				Slider {
					id: volumeSlider;
					from: 0;
					to: 100
					stepSize: 1
					value: plasmoid.configuration.volume * 100
					Layout.fillWidth: true

					ToolTip {
						parent: volumeSlider.handle
						visible: volumeSlider.pressed
						text: volumeSlider.value + "%"
					}
				}

				Label {
					text: volumeSlider.value + "%"
					Layout.minimumWidth: Kirigami.Theme.defaultFont.pointSize * 6
					horizontalAlignment: Text.AlignRight
				}

				Button {
					text: i18n("Test")
					icon.name: "media-playback-start"
					onClicked: {
						testSound.stop();
						testSound.play();
					}
				}
			}
		}
	}
}
