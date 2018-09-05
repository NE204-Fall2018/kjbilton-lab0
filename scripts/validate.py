"""A simple script to verify MD5 checksum across platforms"""
import hashlib

if __name__ == "__main__":

    hasher = hashlib.md5()

    DATAFILE = 'data/lab0_spectral_data'
    try:
        # Read in the existing checksum
        with open(f'{DATAFILE}.md5') as file:
            data = file.read()
            checksum = data.split()[0]

        # Read in the data to compare the checksum to (as binary)
        with open(f'{DATAFILE}.txt', 'rb') as file:
            data = file.read()
            hasher.update(data)
            calculated = hasher.hexdigest()

        assert checksum == calculated
        print('Success -- checksums match')

    except:
        print('Download the data and checksum first.')
