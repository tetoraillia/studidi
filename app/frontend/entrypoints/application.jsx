import React from 'react'
import { createRoot } from 'react-dom/client'
import ChatPage from '../features/pages/chats/ChatPage'

const App = () => {
    return <ChatPage />
}

const container = document.getElementById('react-root')
if (container) {
    const root = createRoot(container)
    root.render(React.createElement(App))
}