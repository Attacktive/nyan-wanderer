import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kcmutils as KCM

Page {
	id: generalPage
	title: i18n("Appearance")

	property alias cfg_imageSize: imageSizeSpinBox.value
	property alias cfg_customImagePath: customImageField.text

	property int cfg_imageSizeDefault: 128
	property string cfg_customImagePathDefault: ""

	FileDialog {
		id: fileDialog
		title: i18n("Choose an image file")
		currentFolder: Qt.resolvedUrl("file://" + customImageField.text || "$HOME")
		nameFilters: [i18n("Image files") + " (*.png *.jpg *.jpeg *.gif)", i18n("All files") + " (*)"]
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

				rightActions: [
					Kirigami.Action {
						icon.name: "document-open"
						tooltip: i18n("Choose image file")
						onTriggered: fileDialog.open()
					},
					Kirigami.Action {
						icon.name: "edit-clear"
						tooltip: i18n("Clear")
						visible: customImageField.text.length > 0
						onTriggered: customImageField.text = ""
					}
				]
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
