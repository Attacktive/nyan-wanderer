import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kcmutils as KCM

Page {
	id: imagePage
	title: i18n("Image")

	property alias cfg_imageSize: imageSizeSpinBox.value
	property alias cfg_defaultImage: defaultImageCombo.currentValue
	property alias cfg_customImagePath: customImageField.text
	property alias cfg_mirrorImage: mirrorImageCheckBox.checked

	property int cfg_imageSizeDefault: 128
	property string cfg_defaultImageDefault: "nyancat"
	property string cfg_customImagePathDefault: ""
	property bool cfg_mirrorImageDefault: false

	readonly property var defaultImages: [
		{ value: "nyancat", label: "Nyan Cat", image: "../../images/nyancat.gif" },
		{ value: "tacnayn", label: "Tac Nayn", image: "../../images/tacnayn.gif" }
	]

	FileDialog {
		id: fileDialog
		title: i18n("Choose an image file")
		currentFolder: Qt.resolvedUrl("file://" + customImageField.text || "$HOME")
		nameFilters: [`${i18n("Image files")} (*.png *.jpg *.jpeg *.gif)`]
		onAccepted: {
			customImageField.text = selectedFile.toString().replace("file://", "")
		}
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Kirigami.Units.smallSpacing

		Kirigami.FormLayout {
			Layout.fillWidth: true

			SpinBox {
				id: imageSizeSpinBox
				Kirigami.FormData.label: i18n("Image size:")
				from: 32
				to: 512
				stepSize: 1
				value: cfg_imageSizeDefault
			}

			ComboBox {
				id: defaultImageCombo
				Kirigami.FormData.label: i18n("Built-in image:")
				model: imagePage.defaultImages
				textRole: "label"
				valueRole: "value"
				currentIndex: imagePage.defaultImages.findIndex(({ value }) => value === cfg_defaultImageDefault)
			}

			Kirigami.ActionTextField {
				id: customImageField
				Kirigami.FormData.label: i18n("Custom image:")
				placeholderText: i18n("Leave empty for built-in image")
				text: cfg_customImagePathDefault
				Layout.fillWidth: true

				readonly property var fileOpeningAction: Kirigami.Action {
					icon.name: "document-open"
					tooltip: i18n("Choose image file")
					onTriggered: fileDialog.open()
				}

				readonly property var clearAction: Kirigami.Action {
					icon.name: "edit-clear"
					tooltip: i18n("Clear")
					visible: customImageField.text.length > 0
					onTriggered: customImageField.text = ""
				}

				rightActions: [fileOpeningAction, clearAction]
			}

			RowLayout {
				id: previewContainer

				readonly property url imagePath: {
					if (customImageField.text.length > 0) {
						return `file://${customImageField.text}`;
					}

					const selected = imagePage.defaultImages.find(({ value }) => value === defaultImageCombo.currentValue);

					return selected?.image ?? "../../images/nyancat.gif";
				}

				AnimatedImage {
					id: preview
					Layout.preferredWidth: 200
					Layout.preferredHeight: 200
					source: previewContainer.imagePath
					playing: true
					mirror: cfg_mirrorImage

					readonly property bool isImageReady: status === AnimatedImage.Ready

					onStatusChanged: playing = (status === AnimatedImage.Ready)
				}
			}

			CheckBox {
				id: mirrorImageCheckBox
				checked: cfg_mirrorImage
				Kirigami.FormData.label: i18n("Mirror Image:")
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
