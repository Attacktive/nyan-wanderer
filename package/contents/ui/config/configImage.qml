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
	property alias cfg_customImagePath: customImageField.text

	property int cfg_imageSizeDefault: 128
	property string cfg_customImagePathDefault: ""

	property alias cfg_speed: speedSlider.value
	property alias cfg_enableRandomIdle: enableRandomIdleCheckBox.checked
	property alias cfg_enableFlipping: enableFlippingCheckBox.checked
	property alias cfg_idleProbability: idleProbabilitySpinBox.value

	property double cfg_speedDefault: 2.0
	property bool cfg_enableRandomIdleDefault: false
	property bool cfg_enableFlippingDefault: true
	property int cfg_idleProbabilityDefault: 30

	// fixme: Of course it's not robust enough.
	readonly property bool isAnimated: customImageField.text.toLowerCase().endsWith(".gif")

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

			Kirigami.ActionTextField {
				id: customImageField
				Kirigami.FormData.label: i18n("Custom image:")
				placeholderText: i18n("Leave empty for default Nyan Cat")
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

				readonly property url imagePath: customImageField.text.length > 0? `file://${customImageField.text}`: "../../images/nyancat.gif"

				AnimatedImage {
					id: preview
					Layout.preferredWidth: 200
					Layout.preferredHeight: 200
					source: previewContainer.imagePath
					playing: true

					readonly property bool isImageReady: status === AnimatedImage.Ready

					onStatusChanged: playing = (status === AnimatedImage.Ready)
				}
			}
		}

		Item {
			Layout.fillHeight: true
		}

		Item {
			visible: false
			Slider { id: speedSlider; value: cfg_speedDefault }
			CheckBox { id: enableRandomIdleCheckBox; checked: cfg_enableRandomIdleDefault }
			CheckBox { id: enableFlippingCheckBox; checked: cfg_enableFlippingDefault }
			SpinBox { id: idleProbabilitySpinBox; value: cfg_idleProbabilityDefault }
		}
	}
}
