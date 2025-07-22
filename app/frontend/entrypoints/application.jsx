import React from 'react'
import { createRoot } from 'react-dom/client'

const App = () => {
    return <h1>App</h1>
}

const container = document.getElementById('react-root')
if (container) {
    const root = createRoot(container)
    root.render(React.createElement(App))
} else {
    console.error('Container #react-root not found')
}