extends Node2D

@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null
var COLLECTION_ID = "user_data"
# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_with_email_and_password(email, password)
	Firebase.Auth.connect("login_succeeded", self._on_FirebaseAuth_login_succeeded)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	##GameManager.userInfo = userinfo
	Firebase.Auth.save_auth(auth_info)


func _on_btn_button_up():
	#adding user to firestore
	var firestore_collection = Firebase.Firestore.collection("user_data")
	var document = firestore_collection.get_doc("VivaVocabulario")
	print(document.data)
	var add_task = firestore_collection.add(userinfo.email, 
	{
		'username': userinfo.email, 
		'level' : 0,
		'points' : 0,
		'score': 0
	})
	
	var addedUser = add_task.data
	print("User added successfully:", addedUser)





func _on_btn_2_button_up():
	
	save_data()
	

func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task: FirestoreTask = collection.get_doc(email)
		var finished_task: FirestoreTask = await task.task_finished
		var document = finished_task.document
		if document && document.doc_fields:
			if document.doc_fields.points:
				var data: Dictionary = {
			"points": document.doc_fields.points + 5
			}
				@warning_ignore("unused_variable")
				var update: FirestoreTask = collection.update(email, data)


#query for limiting input of user data to firestore

func QueryDB():
	var query : FirestoreQuery = FirestoreQuery.new()
	query.from('professor')
	#query.order_by('score', FirestoreQuery.DIRECTION.DESCENDING)
	#query.limit(3)
	var query_task :FirestoreTask = Firebase.Firestore.query(query)
	var result = query_task #,"task_finished"
	print(result.data)

#remopving document from firestore
func removeDocumentData():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('user_data')
	firestore_collection.delete(userinfo.email)
	print("Document deleted successfully")


func _on_btn_4_button_up():
	QueryDB()
	pass # Replace with function body.



func _on_btn_3_button_up():
	pass # Replace with function body.