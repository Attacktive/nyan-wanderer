import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import QtMultimedia

Item {
	id: soundPage;

	property double cfg_volume: plasmoid.configuration.volume

	MediaPlayer {
		id: testSound;
		source: Qt.resolvedUrl("../../effects/meow.mp3");
		audioOutput: AudioOutput {
			volume: soundPage.cfg_volume
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
					value: soundPage.cfg_volume * 100
					onValueChanged: soundPage.cfg_volume = value / 100
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
