import os
import msvcrt  # For Windows
# import sys  # Uncomment this line if running on Unix-based systems and use sys.stdin.read

# Define the note names and their corresponding indices
NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

# Define the intervals for Western and Indian scales
SCALES = {
    "Major": [2, 2, 1, 2, 2, 2, 1],
    "Minor": [2, 1, 2, 2, 1, 2, 2],
    "Pentatonic Major": [2, 2, 3, 2, 3],
    "Pentatonic Minor": [3, 2, 2, 3, 2],
    "Blues": [3, 2, 1, 1, 3, 2],
    "Harmonic Minor": [2, 1, 2, 2, 1, 3, 1],
    "Melodic Minor": [2, 1, 2, 2, 2, 2, 1],
    "Bhairav": [1, 3, 1, 2, 1, 3, 1],  # Indian scale
    "Darbari": [1, 2, 2, 1, 2, 2, 2],  # Indian scale
    "Kafi": [2, 1, 2, 2, 1, 2, 2],     # Indian scale, similar to natural minor
    "Bilawal": [2, 2, 1, 2, 2, 2, 1],  # Indian scale, similar to major scale
}

# Relative major and minor dictionary for Western scales
RELATIVE_MAJOR_MINOR = {
    "C Major": "A Minor",
    "G Major": "E Minor",
    "D Major": "B Minor",
    "A Major": "F# Minor",
    "E Major": "C# Minor",
    "B Major": "G# Minor",
    "F# Major": "D# Minor",
    "C# Major": "A# Minor",
    "F Major": "D Minor",
    "A# Major": "G Minor",
    "D# Major": "C Minor",
    "G# Major": "F Minor",
}

# Mapping Indian scales to their closest Western equivalents for relative scales
INDIAN_RELATIVE_SCALES = {
    "Bhairav": ("C Major", "A Minor"),  # Hypothetical mapping
    "Darbari": ("C Minor", "D# Major"),  # Hypothetical mapping
    "Kafi": ("C Minor", "D# Major"),     # Natural minor
    "Bilawal": ("C Major", "A Minor"),   # Similar to Major
}

def get_scale_notes(key, scale_type):      
    if scale_type not in SCALES:
        raise ValueError(f"Scale type '{scale_type}' is not supported.")
    
    key = key.capitalize()
    if key not in NOTE_NAMES:
        raise ValueError(f"Key '{key}' is not a valid musical note.")

    scale_pattern = SCALES[scale_type]
    key_index = NOTE_NAMES.index(key)

    # Generate the scale
    scale_notes = [NOTE_NAMES[key_index]]
    current_index = key_index

    for interval in scale_pattern:
        current_index = (current_index + interval) % len(NOTE_NAMES)
        scale_notes.append(NOTE_NAMES[current_index])

    return scale_notes

def find_relative_major_minor(key, scale_type):
    if scale_type in ["Major", "Minor"]:
        if scale_type == "Major":
            relative_minor = RELATIVE_MAJOR_MINOR.get(f"{key} Major", "N/A")
            return f"Relative Minor: {relative_minor}"
        elif scale_type == "Minor":
            # Find the relative major by reversing the dictionary lookup
            relative_major = next((k for k, v in RELATIVE_MAJOR_MINOR.items() if v == f"{key} Minor"), "N/A")
            return f"Relative Major: {relative_major}"
    elif scale_type in INDIAN_RELATIVE_SCALES:
        relative_major, relative_minor = INDIAN_RELATIVE_SCALES[scale_type]
        return f"Relative Major: {relative_major} | Relative Minor: {relative_minor}"
    else:
        return ""

def clear_screen():
    # Clear the screen
    os.system('cls' if os.name == 'nt' else 'clear')

def wait_for_keypress():
    if os.name == 'nt':
        msvcrt.getch()  # Wait for a keypress on Windows
    else:
        import sys
        import tty
        import termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

while True:
    clear_screen()  # Clear the screen at the start of each loop iteration
    print("---------------------------------------------------------")
    print("Welcome to the Scale Finder by Skyd 6ix Music")
    print("---------------------------------------------------------")
    
    key = input("Enter the key (e.g., C, D#, A, etc.) or 'exit' to quit: ").capitalize()
    
    if key.lower() == 'exit':
        print("Exiting the program. Goodbye!")
        break

    # Display all scales for the given key
    for scale_type in SCALES:
        try:
            scale_notes = get_scale_notes(key, scale_type)
            print(f"\n{scale_type} scale in the key of {key}: {scale_notes}")
            
            # Show relative major or minor for Western and Indian scales
            relative_scale = find_relative_major_minor(key, scale_type)
            if relative_scale:
                print(relative_scale)
    
        except ValueError as e:
            print(e)

    # Ask for user input to continue or exit
    print("\nPress 'Enter' to continue or 'Esc' to exit.")
    wait_for_keypress()
