from flask import Flask, request, jsonify
from dotenv import load_dotenv
from models import db, Message
from database import init_db
import uuid
import logging
import os


app = Flask(__name__)

load_dotenv()
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://root:{os.getenv('MYSQL_PASSWORD')}@db/message_service"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

logging.basicConfig(level=logging.INFO)

init_db(app)

@app.route('/get/messages/<account_id>', methods=['GET'])
def get_messages(account_id):
    messages = Message.query.filter_by(account_id=account_id).all()
    if not messages:
            return jsonify({'error': 'No messages found for the provided account_id'}), 404
    return jsonify([msg.to_dict() for msg in messages])

@app.route('/create', methods=['POST'])
def create_message():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No input data provided'}), 400
    try:
        new_message = Message(
            account_id=data['account_id'],
            message_id=str(uuid.uuid4()),
            sender_number=data['sender_number'],
            receiver_number=data['receiver_number']
        )
        db.session.add(new_message)
        db.session.commit()
        return jsonify(new_message.to_dict()), 201
    except Exception as e:
        logging.error(f"Error creating message: {e}")
        return jsonify({'error': 'Failed to create message'}), 500

@app.route('/search', methods=['GET'])
def search_messages():
    query = Message.query

    message_ids = request.args.get('message_id')
    if message_ids:
        message_ids = message_ids.split(',')
        query = query.filter(Message.message_id.in_(message_ids))
        if not query.first():
            return jsonify({'error': 'No messages found with the provided message_ids'}), 404

    sender_numbers = request.args.get('sender_number')
    if sender_numbers:
        sender_numbers = sender_numbers.split(',')
        query = query.filter(Message.sender_number.in_(sender_numbers))
        if not query.first():
            return jsonify({'error': 'No messages found with the provided sender_numbers'}), 404

    receiver_numbers = request.args.get('receiver_number')
    if receiver_numbers:
        receiver_numbers = receiver_numbers.split(',')
        query = query.filter(Message.receiver_number.in_(receiver_numbers))
        if not query.first():
            return jsonify({'error': 'No messages found with the provided receiver_numbers'}), 404

    results = query.all()
    return jsonify([msg.to_dict() for msg in results])


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
