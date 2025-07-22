import React from 'react'
import ChatForm from '../../chat/components/ChatForm'

function Chat() {
    const [message, setMessage] = React.useState('');
    const [messages, setMessages] = React.useState([]);
    const [users, setUsers] = React.useState([]);
    const [currentUserId, setCurrentUserId] = React.useState(null);

    React.useEffect(() => {
        const rootEl = document.getElementById('react-root');
        if (rootEl) {
            const data = rootEl.dataset.messages || '[]';
            const usersData = rootEl.dataset.users || '[]';
            try {
                setMessages(JSON.parse(data));
                setUsers(JSON.parse(usersData));
                setCurrentUserId(parseInt(rootEl.dataset.currentUserId, 10));
            } catch (e) {
                console.error('Failed to parse messages JSON', e);
            }
        }
    }, []);

    const handleSend = async () => {
        if (!message.trim()) return;
        try {
            const res = await fetch('/messages', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify({ message: { content: message } })
            });
            if (res.ok) {
                const newMsg = await res.json();
                setMessages(prev => [...prev, newMsg]);
                setMessage('');
            } else {
                console.error('Failed to send');
            }
        } catch (err) {
            console.error(err);
        }
    };

    return (
        <ChatForm messages={messages} users={users} message={message} setMessage={setMessage} handleSend={handleSend} currentUserId={currentUserId} />
    )
}

export default Chat;
