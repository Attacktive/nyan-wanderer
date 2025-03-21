import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kcmutils as KCM

Page {
	id: movementPage
	title: i18n("Movement")

	property alias cfg_enableMovement: enableMovementCheckBox.checked
	property alias cfg_speed: speedSlider.value
	property alias cfg_enableRandomIdle: enableRandomIdleCheckBox.checked
	property alias cfg_enableFlipping: enableFlippingCheckBox.checked
	property alias cfg_idleProbability: idleProbabilitySpinBox.value

	property bool cfg_enableMovementDefault: true
	property double cfg_speedDefault: 2.0
	property bool cfg_enableRandomIdleDefault: false
	property bool cfg_enableFlippingDefault: true
	property int cfg_idleProbabilityDefault: 30

	property alias cfg_imageSize: imageSizeSpinBox.value
	property alias cfg_customImagePath: customImageField.text

	property int cfg_imageSizeDefault: 128
	property string cfg_customImagePathDefault: ""

	ColumnLayout {
		anchors.fill: parent
		spacing: Kirigami.Units.smallSpacing

		Kirigami.FormLayout {
			Layout.fillWidth: true

			CheckBox {
				id: enableMovementCheckBox
				text: i18n("Enabled")
				checked: cfg_enableMovementDefault
			}

			RowLayout {
				Kirigami.FormData.label: i18n("Speed:")
				Layout.fillWidth: true

				Slider {
					id: speedSlider
					Layout.fillWidth: true
					from: 0.5
					to: 10.0
					stepSize: 0.1
					value: cfg_speedDefault
					enabled: enableMovementCheckBox.checked
				}

				Label {
					text: speedSlider.value.toFixed(1) + "×"
					Layout.minimumWidth: Kirigami.Theme.defaultFont.pointSize * 6
					horizontalAlignment: Text.AlignRight
				}
			}

			CheckBox {
				id: enableRandomIdleCheckBox
				Kirigami.FormData.label: i18n("Random Idle:")
				text: i18n("Enabled")
				checked: cfg_enableRandomIdleDefault
				enabled: enableMovementCheckBox.checked
			}

			CheckBox {
				id: enableFlippingCheckBox
				Kirigami.FormData.label: i18n("Image Flipping:")
				text: i18n("Enabled")
				checked: cfg_enableFlippingDefault
				enabled: enableMovementCheckBox.checked
			}

			SpinBox {
				id: idleProbabilitySpinBox
				Kirigami.FormData.label: i18n("Idle Probability (%):")
				from: 1
				to: 100
				value: cfg_idleProbabilityDefault
				enabled: enableMovementCheckBox.checked && enableRandomIdleCheckBox.checked

				Layout.fillWidth: true
				Layout.maximumWidth: Kirigami.Units.gridUnit * 10
			}
		}

		Item {
			Layout.fillHeight: true
		}

		Item {
			visible: false
			SpinBox { id: imageSizeSpinBox; value: cfg_imageSizeDefault }
			TextField { id: customImageField; text: cfg_customImagePathDefault }
		}
	}
}
