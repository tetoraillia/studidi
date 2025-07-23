import React, { useState, useEffect } from 'react'
import ChatForm from '../../chat/components/ChatForm'


function ChatPage() {

  const [messages, setMessages] = useState([])
  const [message, setMessage] = useState('')
  const user = JSON.parse(document.getElementById('react-root').dataset.user)

  useEffect(() => {
    const messageList = document.querySelector('.message-list');
    if (messageList) {
      messageList.scrollTop = messageList.scrollHeight;
    }
  }, [messages]);

  useEffect(() => {
    fetch('/messages', {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        setMessages(data)
        console.log(data)
      })
      .catch(error => console.error('Error fetching messages:', error))
  }, [])


  function sendMessage() {
    if (!message.trim()) return

    console.log('Sending message:', message)

    fetch('/messages', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ message: { content: message } })
    })
      .then(response => {
        if (!response.ok) {
          throw new Error('Failed to send message')
        }
        return response.json()
      })
      .then(data => {
        setMessages(prevMessages => [...prevMessages, data])
        setMessage('')
      })
      .catch(error => {
        console.error('Error sending message:', error)
        alert('Failed to send message. Please try again.')
      })
  }

  return (
    <ChatForm
      messages={messages}
      sendMessage={sendMessage}
      message={message}
      setMessage={setMessage}
      user={user}
    />
  )
}

export default ChatPage;
