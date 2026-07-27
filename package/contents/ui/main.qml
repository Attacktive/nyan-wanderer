import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import QtMultimedia

PlasmoidItem {
	id: root

	property int nyancatSize: plasmoid.configuration.imageSize
	property var defaultImages: ({
		"nyancat": "../images/nyancat.gif",
		"tacnayn": "../images/tacnayn.gif"
	})

	property string imageSource: plasmoid.configuration.customImagePath || defaultImages[plasmoid.configuration.defaultImage] || "../images/nyancat.gif"
	property bool mirrorImage: plasmoid.configuration.mirrorImage
	property bool enableMovement: plasmoid.configuration.enableMovement
	property double speed: plasmoid.configuration.speed
	property bool enableRandomIdle: plasmoid.configuration.enableRandomIdle
	property bool enableFlipping: plasmoid.configuration.enableFlipping
	property int idleProbability: plasmoid.configuration.idleProbability
	property double volume: plasmoid.configuration.volume

	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true
	property bool isIdle: false
	property bool wasIdleBefore: false

	Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
	Plasmoid.status: PlasmaCore.Types.PassiveStatus

	preferredRepresentation: fullRepresentation

	MediaPlayer {
		id: meowSound
		source: plasmoid.configuration.customSoundPath || Qt.resolvedUrl("../effects/meow.mp3");
		audioOutput: AudioOutput {
			volume: root.volume
		}
	}

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
				property bool baseMirror: root.enableFlipping? !root.movingRight: false
				property bool toMirror: root.mirrorImage? !baseMirror: baseMirror

				anchors.fill: parent
				source: root.imageSource
				mirror: toMirror
				playing: true

				onStatusChanged: playing = (status === AnimatedImage.Ready)

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: {
						meowSound.stop()
						meowSound.play()
					}
				}
			}

			Component.onCompleted: {
				if (enableMovement) {
					container.moveToRandomPosition()
				}
			}
		}

		FrameAnimation {
			running: enableMovement

			onTriggered: {
				if (root.isIdle) {
					return
				}

				const step = root.speed * frameTime * 50
				const dx = root.targetPosition.x - imageContainer.x
				const dy = root.targetPosition.y - imageContainer.y
				const length = Math.hypot(dx, dy)

				if (length <= step) {
					imageContainer.x = root.targetPosition.x
					imageContainer.y = root.targetPosition.y
					container.moveToRandomPosition()
				} else {
					imageContainer.x += dx / length * step
					imageContainer.y += dy / length * step
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
