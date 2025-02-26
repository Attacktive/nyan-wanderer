import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
	id: root

	property int nyancatSize: plasmoid.configuration.imageSize
	property int speed: 2
	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true
	property string imageSource: plasmoid.configuration.customImagePath || "../images/nyancat.gif"

	// fixme: Of course it's not robust enough.
	property bool isAnimated: imageSource.toLowerCase().endsWith(".gif")

	Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
	Plasmoid.status: PlasmaCore.Types.PassiveStatus

	preferredRepresentation: fullRepresentation

	fullRepresentation: Item {
		id: container

		function moveToRandomPosition() {
			const targetX = Math.random() * (width - imageContainer.width);
			const targetY = Math.random() * (height - imageContainer.height);

			root.targetPosition = Qt.point(targetX, targetY);
			root.movingRight = targetX > imageContainer.x
		}

		Item {
			id: imageContainer
			width: root.nyancatSize
			height: root.nyancatSize
			x: 0
			y: 0

			AnimatedImage {
				id: animatedImage
				anchors.fill: parent
				source: root.isAnimated ? root.imageSource : ""
				mirror: !root.movingRight
				playing: true
				visible: root.isAnimated
			}

			Image {
				id: staticImage
				anchors.fill: parent
				source: root.isAnimated ? "" : root.imageSource
				mirror: !root.movingRight
				visible: !root.isAnimated
			}

			Component.onCompleted: {
				container.moveToRandomPosition()
			}
		}

		Timer {
			id: moveTimer
			interval: 20
			running: true
			repeat: true

			onTriggered: {
				const dx = root.targetPosition.x - imageContainer.x
				const dy = root.targetPosition.y - imageContainer.y

				if (Math.abs(dx) < root.speed && Math.abs(dy) < root.speed) {
					container.moveToRandomPosition()
				}

				const length = Math.sqrt(dx * dx + dy * dy)

				if (length > 0) {
					imageContainer.x += (dx / length) * root.speed
					imageContainer.y += (dy / length) * root.speed
				}
			}
		}
	}
}
