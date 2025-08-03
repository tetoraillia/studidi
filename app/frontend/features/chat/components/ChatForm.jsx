import React from 'react';
import '../../../../assets/stylesheets/chat.css'

function ChatForm({ messages, sendMessage, message, setMessage, user }) {
  if (!messages) {
    return <div className="chat-container">Loading...</div>;
  }

  return (
    <div className="chat-container">
      <div className="message-list">
        {messages.length === 0 ? (
          <div className="no-messages">No messages </div>
        ) : (
          messages.map((message, index) => {
            const isCurrentUser = message.user_id === user.id;
            return (
              <div
                key={message.id || `msg-${index}`}
                className={`message ${isCurrentUser ? 'my-message' : 'other-message'}`}
              >
                {!isCurrentUser && (
                  <span className="message-user">{message.user_name || 'Anonymous'}: </span>
                )}
                <span className="message-content">{message.content}</span>
              </div>
            );
          })
        )}
      </div>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          sendMessage();
          setMessage('');
        }}
        className="message-form"
      >
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Type your message..."
          className="message-input"
        />
        <button type="submit" className="message-button">Send</button>
      </form>
    </div>
  );
}

export default ChatForm;