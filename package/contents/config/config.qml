import QtQuick
import org.kde.plasma.configuration

ConfigModel {
	ConfigCategory {
		name: i18n("Image")
		icon: "x-shape-image"
		source: "config/configImage.qml"
	}

	ConfigCategory {
		name: i18n("Movement")
		icon: "transform-move"
		source: "config/configMovement.qml"
	}

	ConfigCategory {
		name: i18n("Sound")
		icon: "audio-volume-medium"
		source: "config/configSound.qml"
	}
}
