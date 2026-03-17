from django.conf import settings

def version_to_template(request):
    return {
        'CURRENT_VERSION': getattr(settings, 'APP_VERSION', 'n/a')
    }