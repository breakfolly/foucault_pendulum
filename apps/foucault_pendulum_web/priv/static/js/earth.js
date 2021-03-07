const container = document.getElementById("earth_graph")
const width = container.offsetWidth
const height = container.offsetHeight

const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera( 75, width / height, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer()
renderer.setSize(width, height /2 - 50)
container.appendChild(renderer.domElement)

console.log(width, height)
