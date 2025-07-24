import React, { useState, useEffect, useRef } from 'react';
import ChatForm from '../../chat/components/ChatForm';
import * as ActionCable from '@rails/actioncable';

function ChatPage() {
  const [messages, setMessages] = useState([]);
  const [message, setMessage] = useState('');
  const user = JSON.parse(document.getElementById('react-root').dataset.user);

  const cableRef = useRef(null);
  const subscriptionRef = useRef(null);

  useEffect(() => {
    const messageList = document.querySelector('.message-list');
    if (messageList) {
      messageList.scrollTop = messageList.scrollHeight;
    }
  }, [messages]);

  useEffect(() => {
    cableRef.current = ActionCable.createConsumer('ws://localhost:3000/cable');

    subscriptionRef.current = cableRef.current.subscriptions.create(
      { channel: 'ChatChannel' },
      {
        received: (data) => {
          setMessages((prevMessages) => {
            if (prevMessages.some(msg => msg.id === data.id)) return prevMessages;

            const tempMessageIndex = prevMessages.findIndex(msg =>
              String(msg.id).startsWith('temp-') &&
              msg.content === data.content &&
              msg.user_id === user.id
            );

            if (tempMessageIndex !== -1) {
              return prevMessages.filter((_, index) => index !== tempMessageIndex).concat({
                ...data,
                user_id: user.id,
                user_name: user.name
              });
            }

            return [...prevMessages, data];
          });
        },
      }
    );

    fetch('/messages', {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => setMessages(data))
      .catch(error => console.error('Error fetching messages:', error));

    return () => {
      subscriptionRef.current?.unsubscribe();
      cableRef.current?.disconnect();
    };
  }, []);

  function sendMessage() {
    if (!message.trim()) return;

    if (!subscriptionRef.current) {
      alert('Connection not stable. Please refresh.');
      return;
    }

    const tempMessage = {
      id: `temp-${Date.now()}`,
      content: message,
      user_id: user.id,
      user_name: user.name,
      created_at: new Date().toISOString()
    };

    setMessages(prev => [...prev, tempMessage]);
    subscriptionRef.current.perform("receive", { content: message });
    setMessage('');
  }


  return (
    <ChatForm
      messages={messages}
      sendMessage={sendMessage}
      message={message}
      setMessage={setMessage}
      user={user}
    />
  );
}

export default ChatPage;