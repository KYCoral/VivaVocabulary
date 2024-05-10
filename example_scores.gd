extends Node2D

@export var email : String = "kazumirimurutempest@gmail.com"
@export var password : String = "password123"
var userinfo = null

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
	# adding user to firestore
	var firestore_collection = Firebase.Firestore.collection("user_data")
	var document = firestore_collection.get_doc("VivaVocabulario")
	print(document)
	var add_task = firestore_collection.add(userinfo.email, 
	{
		'username': userinfo.email, 
		'level' : 0,
		'points' : 0,
		'score': 0
	})
	var addedUser = add_task
	print("User added successfully:", addedUser)




func _on_btn_2_button_up():
	var firestore_collection = Firebase.Firestore.collection("user_data")
	#var document = firestore_collection.get_doc("VivaVocabulario")
	firestore_collection.update(userinfo.email, 
	{
		'username': userinfo.email, 
		'level' : 1,
		'points' : 3,
		'score': 30
	})
	#var document : FirestoreDocument = up_task.get("task_finished")


func _on_btn_3_button_up():
	removeDocumentData()


#query for limiting input of user data to firestore

func QueryDB():
	var query : FirestoreQuery = FirestoreQuery.new()
	query.from('user_data')
	query.order_by('score', FirestoreQuery.DIRECTION.DESCENDING)
	query.limit(3)
	var query_task :FirestoreTask = Firebase.Firestore.query(query)
	var result = query_task #,"task_finished"
	print(result)

#remopving document from firestore
func removeDocumentData():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('user_data')
	firestore_collection.delete(userinfo.email)
	print("Document deleted successfully")


func _on_btn_4_button_up():
	QueryDB()
	pass # Replace with function body.

