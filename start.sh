python manage.py shell << 'EOF'
from django.contrib.auth import get_user_model, authenticate
from django.conf import settings
import os

User = get_user_model()
USERNAME_FIELD = User.USERNAME_FIELD

username = os.environ.get("DJANGO_SUPERUSER_USERNAME")
email = os.environ.get("DJANGO_SUPERUSER_EMAIL")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD")

login_value = username if USERNAME_FIELD == "username" else email

print("AUTH_USER_MODEL =", settings.AUTH_USER_MODEL)
print("USERNAME_FIELD =", USERNAME_FIELD)
print("AUTHENTICATION_BACKENDS =", settings.AUTHENTICATION_BACKENDS)
print("LOGIN VALUE USED =", login_value)

user, created = User.objects.get_or_create(
    **{USERNAME_FIELD: login_value},
    defaults={"email": email}
)

user.is_staff = True
user.is_superuser = True
user.set_password(password)
user.save()

print("Admin ensured")

test = authenticate(**{USERNAME_FIELD: login_value}, password=password)
print("AUTHENTICATE RESULT =", test)
EOF
