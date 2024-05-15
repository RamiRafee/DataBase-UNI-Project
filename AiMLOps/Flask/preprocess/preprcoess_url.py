from urllib.parse import urlparse
import re
from tld import get_tld
import pandas as pd


def preprocess_url(url):
    # Function to preprocess URL and extract features
    def having_ip_address(url):
        match = re.search(
            '(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.'
            '([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\/)|'  # IPv4
            # IPv4 in hexadecimal
            '((0x[0-9a-fA-F]{1,2})\\.(0x[0-9a-fA-F]{1,2})\\.(0x[0-9a-fA-F]{1,2})\\.(0x[0-9a-fA-F]{1,2})\\/)'
            '(?:[a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}', url)  # Ipv6
        if match:
            return 1
        else:
            return 0

    def abnormal_url(url):
        hostname = urlparse(url).hostname
        hostname = str(hostname)
        match = re.search(hostname, url)
        if match:
            return 1
        else:
            return 0

    def no_of_dir(url):
        urldir = urlparse(url).path
        return urldir.count('/')

    def no_of_embed(url):
        urldir = urlparse(url).path
        return urldir.count('//')

    def shortening_service(url):
        match = re.search('bit\.ly|goo\.gl|shorte\.st|go2l\.ink|x\.co|ow\.ly|t\.co|tinyurl|tr\.im|is\.gd|cli\.gs|'
                          'yfrog\.com|migre\.me|ff\.im|tiny\.cc|url4\.eu|twit\.ac|su\.pr|twurl\.nl|snipurl\.com|'
                          'short\.to|BudURL\.com|ping\.fm|post\.ly|Just\.as|bkite\.com|snipr\.com|fic\.kr|loopt\.us|'
                          'doiop\.com|short\.ie|kl\.am|wp\.me|rubyurl\.com|om\.ly|to\.ly|bit\.do|t\.co|lnkd\.in|'
                          'db\.tt|qr\.ae|adf\.ly|goo\.gl|bitly\.com|cur\.lv|tinyurl\.com|ow\.ly|bit\.ly|ity\.im|'
                          'q\.gs|is\.gd|po\.st|bc\.vc|twitthis\.com|u\.to|j\.mp|buzurl\.com|cutt\.us|u\.bb|yourls\.org|'
                          'x\.co|prettylinkpro\.com|scrnch\.me|filoops\.info|vzturl\.com|qr\.net|1url\.com|tweez\.me|v\.gd|'
                          'tr\.im|link\.zip\.net',
                          url)
        if match:
            return 1
        else:
            return 0

    def suspicious_words(url):
        match = re.search('PayPal|login|signin|bank|account|update|free|lucky|service|bonus|ebayisapi|webscr',
                          url)
        if match:
            return 1
        else:
            return 0

    def fd_length(url):
        urlpath = urlparse(url).path
        try:
            return len(urlpath.split('/')[1])
        except:
            return 0

    def tld_length(tld):
        try:
            return len(tld)
        except:
            return -1

    def digit_count(url):
        digits = 0
        for i in url:
            if i.isnumeric():
                digits = digits + 1
        return digits

    def letter_count(url):
        letters = 0
        for i in url:
            if i.isalpha():
                letters = letters + 1
        return letters

    use_of_ip = having_ip_address(url)
    abnormal = abnormal_url(url)
    count_dot = url.count('.')
    count_www = url.count('www')
    count_at = url.count('@')
    count_dir = no_of_dir(url)
    count_embed = no_of_embed(url)
    short_url = shortening_service(url)
    count_https = url.count('https')
    count_http = url.count('http')
    count_percent = url.count('%')
    count_question = url.count('?')
    count_hyphen = url.count('-')
    count_equal = url.count('=')
    url_length = len(url)
    hostname_length = len(urlparse(url).netloc)
    sus_url = suspicious_words(url)
    first_dir_length = fd_length(url)
    tld = get_tld(url, fail_silently=True)
    tld_length_val = tld_length(tld)
    count_digits = digit_count(url)
    count_letters = letter_count(url)

    # Creating a DataFrame for the URL
    df = pd.DataFrame({
        'use_of_ip': [use_of_ip],
        'abnormal_url': [abnormal],
        'count_dot': [count_dot],
        'count_www': [count_www],
        'count_at': [count_at],
        'count_dir': [count_dir],
        'count_embed': [count_embed],
        'short_url': [short_url],
        'count_https': [count_https],
        'count_http': [count_http],
        'count_percent': [count_percent],
        'count_question': [count_question],
        'count_hyphen': [count_hyphen],
        'count_equal': [count_equal],
        'url_length': [url_length],
        'hostname_length': [hostname_length],
        'sus_url': [sus_url],
        'first_dir_length': [first_dir_length],
        'tld_length': [tld_length_val],
        'count_digits': [count_digits],
        'count_letters': [count_letters]
    })

    return df