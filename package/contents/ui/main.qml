import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
	id: root

	property int nyancatSize: plasmoid.configuration.imageSize
	property string imageSource: plasmoid.configuration.customImagePath || "../images/nyancat.gif"
	property bool enableMovement: plasmoid.configuration.enableMovement || true
	property double speed: plasmoid.configuration.speed
	property bool enableRandomIdle: plasmoid.configuration.enableRandomIdle
	property bool enableFlipping: plasmoid.configuration.enableFlipping
	property int idleProbability: plasmoid.configuration.idleProbability

	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true
	property bool isIdle: false
	property bool wasIdleBefore: false

	// fixme: Of course it's not robust enough.
	readonly property bool isAnimated: imageSource.toLowerCase().endsWith(".gif")

	Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
	Plasmoid.status: PlasmaCore.Types.PassiveStatus

	preferredRepresentation: fullRepresentation

	fullRepresentation: Item {
		id: container

		function moveToRandomPosition() {
			if (enableRandomIdle && !isIdle && wasIdleBefore && Math.random() * 100 < idleProbability) {
				isIdle = true;
				wasIdleBefore = true;
				idleTimer.start();
				return;
			}

			wasIdleBefore = true;
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
				anchors.fill: parent
				source: root.imageSource
				mirror: root.enableFlipping ? !root.movingRight : false
				playing: true

				onStatusChanged: playing = (status === AnimatedImage.Ready)
			}

			Component.onCompleted: {
				if (enableMovement) {
					container.moveToRandomPosition()
				}
			}
		}

		Timer {
			id: moveTimer
			running: enableMovement
			interval: 20
			repeat: true

			onTriggered: {
				if (root.isIdle) {
					return;
				}

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

		Timer {
			id: idleTimer
			running: enableMovement
			interval: 2000
			repeat: false
			onTriggered: {
				isIdle = false;
				wasIdleBefore = false;
				container.moveToRandomPosition();
			}
		}
	}
}
