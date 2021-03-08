// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

const drawPantheon2d = (ctx) => {
  window.myScatter = new Chart(ctx, {
    type: 'scatter',
    data: {
        datasets: [{
          fill: false,
          data: [],
		  borderColor: 'black',
		  borderWidth: 1,
		  pointRadius: 3,
		  showLine: true
       
        }]
    },
    options: {
      scales: {
        xAxes: [{
          ticks: {
            max: 2.0,
            min: -2.0,
            stepSize: 0.5
          }
        }],
        yAxes: [{
          ticks: {
            max: 2.0,
            min: -2.0,
            stepSize: 0.5
          }
        }]
      },
      legend: { display: false },
      responsive: true,
      title: { display: false },
	  animation: { duration: 0 }
    }
  })
}

let Hooks = {}
Hooks.pantheon2d = {
  mounted() {
	var ctx = this.el.getContext('2d')
	drawPantheon2d(ctx)
  } 
}

Hooks.updatePantheon2d = {
  updated() {
    window.myScatter.data.datasets.forEach((dataset) => 
		dataset.data.push(JSON.parse(this.el.dataset.pantheon2d))
	)
	window.myScatter.update()
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

