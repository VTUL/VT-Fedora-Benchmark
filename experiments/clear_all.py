import pycurl
import os
import sys


def delete_fedora_object(fedora_url):
    c = pycurl.Curl()
    c.setopt(c.URL, fedora_url)
    c.setopt(c.CUSTOMREQUEST, "DELETE")
    c.perform()
    c.close()


def main(fedora_urls, results_destination=None):
    with open(fedora_urls) as f:
        lines = f.readlines()

    for line in lines:
        fedora_url = line.strip()

        print "Deleting " + fedora_url
        delete_fedora_object(fedora_url)
        delete_fedora_object(fedora_url + "/fcr:tombstone")
        print "Deletion successful"

    for file in os.listdir(results_destination or "."):
        if file.endswith(".csv"):
            os.remove(file)
    os.remove(fedora_urls)


if __name__ == "__main__": main(sys.argv[1])
