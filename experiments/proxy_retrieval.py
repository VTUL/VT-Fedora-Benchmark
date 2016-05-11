import datetime
import sys, os
import time
import json
import pycurl

from subprocess import call
from StringIO import StringIO


# Read Fedora object
def read_fedora_object(fedora_url):
    storage = StringIO()
    c = pycurl.Curl()
    c.setopt(c.URL, fedora_url)
    c.setopt(pycurl.HTTPHEADER, ["Accept: application/ld+json"])
    c.setopt(c.WRITEFUNCTION, storage.write)
    c.perform()
    c.close()
    content = storage.getvalue()

    return content


def run(work_item_client):
    output_file = open("experiment_proxy_retrieval_{}_results.csv".format(datetime.date.today()), "a")

    progress = []

    start = str(datetime.datetime.now())
    tic = time.time()

    file_name = "temp.h5"
    while True:
        # obtain work item from work_item_client (see commons.py for implementations)
        work_item = work_item_client.get_work_item()
        if not work_item:
            break
        fedora_obj_url = work_item.strip()

        # retrieve file url from Fedora
        url = time.time()
        content = read_fedora_object(fedora_obj_url)
        fedora_content_url = str(json.loads(content)[0]['http://purl.org/dc/elements/1.1/source'][0]['@value'])
        progress.append("UrlFetch," + fedora_obj_url + "," + str(url) + "," + str(time.time()))

        # download hdf5 file
        download = time.time()
        call("wget -nv " + fedora_content_url + " -O " + file_name, shell=True)
        progress.append("Download," + fedora_obj_url + "," + str(download) + "," + str(time.time()))

        # cleanup
        os.remove(file_name)

    duration = str(time.time() - tic)
    end = str(datetime.datetime.now())
    print duration
    progress.insert(0, "OVERALL EXECUTION," + start + "," + duration + "," + end)
    for line in progress:
        output_file.write(line + "\n")
    output_file.close()


if __name__ == "__main__":
    fedora_urls_filename = sys.argv[1]

    from commons import FileSystemClient

    run(FileSystemClient(fedora_urls_filename))
