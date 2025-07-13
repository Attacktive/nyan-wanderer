import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import QtMultimedia

Item {
	id: soundPage;

	property double cfg_volume: plasmoid.configuration.volume
	property string cfg_customSoundPath: plasmoid.configuration.customSoundPath

	MediaPlayer {
		id: testSound;
		source: cfg_customSoundPath || Qt.resolvedUrl("../../effects/meow.mp3");
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

			RowLayout {
				Kirigami.FormData.label: i18n("Custom sound:")
				Layout.fillWidth: true

				TextField {
					id: soundPathField
					text: soundPage.cfg_customSoundPath
					placeholderText: i18n("Path to custom sound file")
					Layout.fillWidth: true
					readOnly: true
				}

				Button {
					text: i18n("Browse...")
					icon.name: "folder-open"
					onClicked: soundFileDialog.open()
				}

				Button {
					text: i18n("Reset")
					icon.name: "edit-undo"
					enabled: soundPage.cfg_customSoundPath !== ""
					onClicked: soundPage.cfg_customSoundPath = ""
				}
			}
		}
	}

	FileDialog {
		id: soundFileDialog
		title: i18n("Choose a sound file")
		currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
		nameFilters: [i18n("Audio files (*.mp3 *.wav *.ogg)"), i18n("All files (*)")]
		onAccepted: soundPage.cfg_customSoundPath = selectedFile
	}
}
