import 'package:flutter/material.dart';
import 'package:chatboat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedinUser;


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String Textmessage;

  @override
  void initState() {
      super.initState();
    getCurrentUser();
  }

  void getCurrentUser()async{
    try{
    final user = await _auth.currentUser;
    if(user!=null){
      loggedinUser = user;
      print(loggedinUser);
    }
    }
    catch(e){
      print(e);
    }
  }
  
  void messageStream() async{
  await for(var snapshot in _firestore.collection('messages').snapshots()){
    for(var message in snapshot.docs){
      print(message.data);
    }
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.directions_run),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                messageStream();
              }),
        ],
        title: Text('ChatBoat Group',textAlign: TextAlign.center,),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextcontroller,
                      onChanged: (value) {
                        Textmessage=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text' : Textmessage,
                        'sender' : loggedinUser.email,
                        'time': FieldValue.serverTimestamp() //added this
                      });
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        child: Row(
                          children: [
                            Text('Ship',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),),
                            Icon(
                              Icons.directions_boat,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('time', descending: false)//added this
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            );
          }
          {
            final messages = snapshot.data?.docs.reversed;
            List<MessageBubble> messageBubbles =[];
            for (var message in messages!){
              final messageText = message.get('text');
              final messagesender = message.get('sender');
              final messageTime = message.get('time') as Timestamp; //added this
              final currentUser = loggedinUser.email;

              if(currentUser == messagesender){

              }

              final messageBubble = MessageBubble(
                messageText,
                messagesender,
                currentUser == messagesender,
                messageTime, //added this
              );
              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                children: messageBubbles,
              ),
            );
          }
          return SizedBox();
        });
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble(this.message,this.sender,this.isMe,this.time); //added the variable  in this constructor
  final String sender;
  final String message;
  final bool isMe;
  final Timestamp time; // added this

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 2,
            borderRadius: isMe?
            BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),topRight: Radius.circular(20)):
          BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),topRight: Radius.circular(20)),
              color: isMe?Colors.orangeAccent:Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                child: Column(
                  crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    Text('$message',style: TextStyle(fontSize: 17,color:isMe? Colors.white:Colors.black54),),
                    Text('$sender',style: TextStyle(fontSize: 10,color: Colors.black45),),
                    Text('${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}',style: TextStyle(fontSize: 8,color: Colors.black45))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
