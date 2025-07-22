import React, { useEffect, useRef } from 'react'
import '../../../../assets/stylesheets/chat.css'

function ChatForm({ messages, users, message, setMessage, handleSend, currentUserId }) {
    const messagesEndRef = useRef(null);

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    return (
        <div className="chat-container">
            <div className="messages">
                {messages.map((msg) => {
                    const user = users.find((u) => u.id === msg.user_id);
                    const isMe = msg.user_id === currentUserId;

                    return (
                        <div key={msg.id} className={`message ${isMe ? "me" : "other"}`}>
                            <strong>{user ? `${user.first_name} ${user.last_name}` : "Unknown"}</strong>
                            {msg.content}
                        </div>
                    );
                })}
                <div ref={messagesEndRef} />
            </div>

            <div className="input-area">
                <input
                    type="text"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    placeholder="Type your message..."
                />
                <button onClick={handleSend}>Send</button>
            </div>
        </div>
    );
}

export default ChatForm;
