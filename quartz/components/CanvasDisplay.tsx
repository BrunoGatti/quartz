import { QuartzComponentProps } from "./types"

export default ((opts?: { canvasWidth: number; canvasHeight: number }) => {
  const defaultOpts = { canvasWidth: 800, canvasHeight: 600 }
  const options = { ...defaultOpts, ...opts }

  function CanvasDisplay(props: QuartzComponentProps) {
    return (
      <canvas id="myCanvas" width={options.canvasWidth} height={options.canvasHeight}></canvas>
    )
  }

  CanvasDisplay.afterDOMLoaded = `
    const canvas = document.getElementById('myCanvas');
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = 'green';
    ctx.fillRect(10, 10, 150, 100);
  `

  return CanvasDisplay
}) satisfies QuartzComponentConstructor

