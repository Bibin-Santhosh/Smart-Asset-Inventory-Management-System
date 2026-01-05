from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
import os

class Command(BaseCommand):
    help = "Ensure admin user exists and has correct password"

    def handle(self, *args, **options):
        User = get_user_model()

        username = os.environ.get("DJANGO_SUPERUSER_USERNAME", "admin")
        email = os.environ.get("DJANGO_SUPERUSER_EMAIL", "admin@example.com")
        password = os.environ.get("DJANGO_SUPERUSER_PASSWORD", "Admin@123")

        # Try username OR email (covers custom user models)
        user = (
            User.objects.filter(username=username).first()
            or User.objects.filter(email=email).first()
        )

        if not user:
            user = User.objects.create(
                username=username,
                email=email,
                is_staff=True,
                is_superuser=True,
            )
            self.stdout.write("Admin user CREATED")
        else:
            self.stdout.write("Admin user FOUND")

        user.is_staff = True
        user.is_superuser = True
        user.set_password(password)
        user.save()

        self.stdout.write("Admin password SET successfully")
