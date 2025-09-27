
import firebase_admin
from firebase_admin import credentials, firestore, auth
import getpass

# Initialize Firebase Admin SDK
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)

db = firestore.client()

def main():
    """Creates the initial super admin user."""

    print("Creating the super admin user...")

    # Check if a super admin already exists
    super_admin_ref = db.collection("users").where("role", "==", "super_admin").limit(1)
    if len(list(super_admin_ref.get())) > 0:
        print("A super admin user already exists. Aborting.")
        return

    # Get super admin details from user input
    full_name = input("Enter full name: ")
    email = input("Enter email: ")
    password = getpass.getpass("Enter password: ")

    try:
        # Create user in Firebase Authentication
        user = auth.create_user(email=email, password=password)

        # Create user in Firestore
        user_data = {
            "name": full_name,
            "email": email,
            "role": "super_admin",
            "createdAt": firestore.SERVER_TIMESTAMP,
        }
        db.collection("users").document(user.uid).set(user_data)

        print("Super admin user created successfully!")
        print(f"User ID: {user.uid}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
