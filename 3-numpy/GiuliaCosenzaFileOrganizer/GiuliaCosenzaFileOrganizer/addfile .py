import os
import shutil
import csv
import argparse

# Mappatura delle estensioni dei file
EXTENSIONS = {
    'audio': [".aac", ".aif", ".aiff", ".alac", ".amr", ".ape", ".flac", ".m4a", ".mp3", ".mpc", ".ogg", ".opus", ".ra", ".ram", ".wav", ".wma", ".3gp", ".audiobook", ".mid", ".midi", ".dsd", ".cda"],
    'doc': [".txt", ".doc", ".docx", ".odt", ".rtf", ".pdf", ".md", ".tex", ".log", ".csv", ".tsv", ".xml", ".json", ".yaml", ".html", ".css", ".ini", ".cfg"],
    'image': [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp", ".svg", ".heif", ".heic", ".ico", ".raw", ".nef", ".cr2", ".dng", ".eps", ".ai", ".psd"]
}

# Funzione per determinare il tipo di file
def get_file_info(file_name):
    _, ext = os.path.splitext(file_name)
    ext = ext.lower()
    
    for file_type, extensions in EXTENSIONS.items():
        if ext in extensions:
            return [file_name, file_type, os.path.getsize(file_name)]
    return [file_name, 'other', os.path.getsize(file_name)]

# Funzione per aggiungere le informazioni al file recap.csv
def update_recap(file_info):
    recap_path = './files/recap.csv'
    file_exists = os.path.exists(recap_path)
    file_info[0]=os.path.basename(file_info[0])
    file_info[0] = os.path.splitext(os.path.basename(file_info[0]))[0]

    
    with open(recap_path, mode='a', newline='') as file:
        writer = csv.writer(file)
        if not file_exists:
            writer.writerow(['File Name', 'Type', 'SizeB'])
        writer.writerow(file_info)


# Funzione per spostare il file considerando la casistica che un file con lo stesso nome potrebbe già esistere nella cartella
#Qui c'è una piccola interazione con l'utente perchè spostando il file uno a uno c'è il controllo dell'utente sulla scelta di duplicarlo se esiste gia un omonimo
def move_file_with_rename(src_path, dest_dir):
    # Estrai il nome e l'estensione del file
    base_name = os.path.basename(src_path)
    name, ext = os.path.splitext(base_name)
    
    # Costruire il percorso completo di destinazione
    dest_path = os.path.join(dest_dir, base_name)
    
    # Controllare se il file esiste già nella destinazione e chiedere all'utente se si vuole spostare comunque
    if os.path.exists(dest_path):
        while True:
            user_response = input(f"Il file '{base_name}' esiste già nella cartella '{dest_dir}'. Vuoi spostare comunque il file? (s/n): ")
            if user_response.lower() == 's':
                break
            elif user_response.lower() == 'n':
                return f"Operazione annullata: il file '{base_name}' non è stato spostato."
            else:
                print("Risposta non valida. Per favore, digita 's' per sì o 'n' per no.")
    
    # Se il file esiste già e l'utente ha detto 's', aggiungere un suffisso numerico per evitare sovrascrittura
    counter = 1
    new_base_name = base_name
    while os.path.exists(dest_path):
        # Creare un nuovo nome aggiungendo un suffisso numerico
        new_name = f"{name}({counter}){ext}"
        new_base_name = new_name
        dest_path = os.path.join(dest_dir, new_name)
        counter += 1
    
    # Spostare e rinomina il file
    shutil.move(src_path, dest_path)
    return new_base_name


# Funzione per spostare il file nella cartella corretta
def sposta_file(file_name):
    # Verificare se il file esiste nella cartella 'files'
    files_directory = './files'
    file_path = os.path.join(files_directory, file_name)
    
    if not os.path.exists(file_path):
        return f"Errore: il file '{file_name}' non esiste nella cartella '/files'."
    
    # Creare le directory se non esistono
    for directory in ["audio", "docs", "images"]:
        os.makedirs(os.path.join(files_directory, directory), exist_ok=True)

    # Determinare il tipo di file
    file_info = get_file_info(file_path)
    
    if file_info[1] == 'other':  # Se il file non è audio, doc o immagine
        return f"Errore: il file '{file_name}' non appartiene a nessuna delle categorie supportate (audio, doc, immagine)."
    
    
    # Mappatura dei tipi di file per usare le cartelle al plurale
    folder_mapping = {
        'audio': 'audio',    # "audio" -> "audio" 
        'doc': 'docs',       # "doc" -> "docs"
        'image': 'images'    # "image" -> "images"
    }

    # Spostamento del file nella cartella corrispondente
    target_dir = folder_mapping[file_info[1]]  
    target_path = os.path.join(files_directory, target_dir)
    file_info[0] = move_file_with_rename(file_path, target_path)

    # Aggiungere il file al recap.csv
    update_recap(file_info)

    return f"Il file '{file_name}' è stato spostato nella cartella '{target_dir}' e il recap è stato aggiornato."

# Configurazione del parser per la CLI
def main():
    parser = argparse.ArgumentParser(
        prog='addfile.py',
        description='Programma per spostare un file alla volta nella cartella più adatta in base alla sua classificazione come file audio, doc o immagine.'
    )
    parser.add_argument("file_name", type=str, help="Il nome del file da spostare (incluso il formato, es: 'trump.jpeg')")
    args = parser.parse_args()

    # Chiamare la funzione di spostamento del file per farla eseguire
    result = sposta_file(args.file_name)
    print(result)

if __name__ == "__main__":
    main()