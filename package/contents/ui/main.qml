import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
	id: root

	property int nyancatSize: 128
	property int speed: 2
	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true

	preferredRepresentation: fullRepresentation

	fullRepresentation: Item {
		id: container

		AnimatedImage {
			id: nyancatImage
			width: root.nyancatSize
			height: root.nyancatSize
			source: "../images/nyancat.gif"
			mirror: !root.movingRight
			playing: true

			Timer {
				id: moveTimer
				interval: 20
				running: true
				repeat: true

				onTriggered: {
					const dx = root.targetPosition.x - nyancatImage.x
					const dy = root.targetPosition.y - nyancatImage.y

					if (Math.abs(dx) < root.speed && Math.abs(dy) < root.speed) {
						root.targetPosition = Qt.point(
							Math.random() * (container.width - nyancatImage.width),
							Math.random() * (container.height - nyancatImage.height)
						)

						root.movingRight = root.targetPosition.x > nyancatImage.x
					}

					const length = Math.sqrt(dx * dx + dy * dy)

					if (length > 0) {
						nyancatImage.x += (dx / length) * root.speed
						nyancatImage.y += (dy / length) * root.speed
					}
				}
			}
		}
	}

	Component.onCompleted: {
		root.targetPosition = Qt.point(
			Math.random() * (container.width - nyancatImage.width),
			Math.random() * (container.height - nyancatImage.height)
		)
	}
}
