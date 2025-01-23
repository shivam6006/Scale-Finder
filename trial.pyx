import tkinter as tk
from tkinter import messagebox, font

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
    "Bhairavi": [1, 2, 1, 2, 1, 3, 1]  # Added Bhairavi scale
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
    "Bhairavi": ("C Major", "A Minor")   # Hypothetical mapping
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

def display_scale(event=None):
    key = entry_key.get().capitalize()
    if key.lower() == 'exit':
        confirm_exit()
        return

    output_text.config(state=tk.NORMAL)  # Enable text widget for writing
    output_text.delete(1.0, tk.END)  # Clear previous output

    for scale_type in SCALES:
        try:
            scale_notes = get_scale_notes(key, scale_type)
            output_text.insert(tk.END, f"\n{scale_type} scale in the key of {key}: {scale_notes}\n", "scale")
            
            # Show relative major or minor for Western and Indian scales
            relative_scale = find_relative_major_minor(key, scale_type)
            if relative_scale:
                output_text.insert(tk.END, f"{relative_scale}\n", "relative")
    
        except ValueError as e:
            messagebox.showerror("Error", str(e))
            output_text.config(state=tk.DISABLED)  # Disable text widget after writing
            return

    output_text.insert(tk.END, "\nPress 'Clear' to reset or 'Exit' to close the application.", "info")
    output_text.config(state=tk.DISABLED)  # Disable text widget after writing

def toggle_theme():
    dark_theme = window.cget("bg") == "white"
    bg_color = "#1e1e1e" if dark_theme else "white"
    text_color = "white" if dark_theme else "black"
    scale_color = "white" if dark_theme else "black"
    relative_color = "lightgreen" if dark_theme else "green"
    info_color = "lightcoral" if dark_theme else "red"
    button_bg_color = "black" if dark_theme else "white"
    button_fg_color = "white" if dark_theme else "black"
    highlight_color = "white" if dark_theme else "black"
    
    window.config(bg=bg_color)
    output_text.config(bg=bg_color, fg=text_color)
    output_text.tag_config("scale", foreground=scale_color)
    output_text.tag_config("relative", foreground=relative_color)
    output_text.tag_config("info", foreground=info_color)
    
    for widget in window.winfo_children():
        if isinstance(widget, tk.Button) or isinstance(widget, tk.Label):
            widget.config(bg=button_bg_color, fg=button_fg_color, highlightbackground=highlight_color)
    
    for widget in button_frame.winfo_children():
        widget.config(bg=button_bg_color, fg=button_fg_color, highlightbackground=highlight_color)

def animate_button(button):
    # Define a list of colors for animation including the initial color
    colors = ["#2e2e2e", "#ff4500", "#ff6347", "#ff8c00", "#ffa500"]
    current_color = button.cget("bg")
    
    if current_color not in colors:
        current_color = "#2e2e2e"  # Set a default if current color is not in the list

    next_color = colors[(colors.index(current_color) + 1) % len(colors)]
    button.config(bg=next_color, relief=tk.RAISED, highlightbackground="white", highlightthickness=2, borderwidth=0, padx=10, pady=5)
    window.after(500, animate_button, button)  # Adjust delay as needed

def animate_scale_display():
    current_text = output_text.get(1.0, tk.END).strip()
    display_text = "Scaling..."
    output_text.config(state=tk.NORMAL)
    output_text.delete(1.0, tk.END)
    output_text.insert(tk.END, display_text, "info")
    window.after(500, lambda: output_text.insert(tk.END, current_text))  # Restore original text after animation
    output_text.config(state=tk.DISABLED)

def toggle_fullscreen():
    is_fullscreen = window.attributes("-fullscreen")
    window.attributes("-fullscreen", not is_fullscreen)

def confirm_exit():
    if messagebox.askokcancel("Exit", "Do you really want to exit?"):
        window.quit()
        
def clear_output():
    output_text.config(state=tk.NORMAL)
    output_text.delete(1.0, tk.END)
    entry_key.delete(0, tk.END)  # Clear the input field
    output_text.config(state=tk.DISABLED)

# Initialize the GUI window
window = tk.Tk()
window.title("SCALE FINDER")

# Allow resizing
window.geometry("800x600")
window.minsize(800, 400)

# Set up color tags for text display
output_text = tk.Text(window, height=15, width=70, font=("Ubuntu Medium", 12), state=tk.DISABLED)  # Set state to DISABLED initially
output_text.tag_config("scale", foreground="black")
output_text.tag_config("relative", foreground="green")
output_text.tag_config("info", foreground="red")
output_text.pack(expand=True, fill=tk.BOTH, padx=10, pady=10)

# Entry for key input
tk.Label(window, text="Enter the key (e.g., C, D#, A, etc.):", font=("Ubuntu Bold", 12)).pack(pady=5)
entry_key = tk.Entry(window, font=("Ubuntu Regular", 20))
entry_key.pack(pady=5)
entry_key.bind("<Return>", display_scale)  # Bind Enter key to display_scale function

# Frame for buttons
button_frame = tk.Frame(window, bg=window.cget("bg"))
button_frame.pack(pady=10)

# Create buttons with rounded appearance and improved UI
def create_button(parent, text, command):
    button = tk.Button(parent, text=text, command=command, bg="#2e2e2e", fg="white", font=("Ubuntu Bold", 12), relief=tk.RAISED, highlightbackground="Black", highlightthickness=2, borderwidth=0, padx=10, pady=5)
    button.bind("<Enter>", lambda e: button.config(bg="grey"))  # Hover effect
    button.bind("<Leave>", lambda e: button.config(bg="#2e2e2e"))
    return button

# Button to display the scale
show_scale_button = create_button(button_frame, "Show Scale", display_scale)
show_scale_button.pack(side=tk.LEFT, padx=5)

# Button to clear the output and input
clear_button = create_button(button_frame, "Clear", clear_output)
clear_button.pack(side=tk.LEFT, padx=5)

# Button to exit the application
exit_button = create_button(button_frame, "Exit", confirm_exit)
exit_button.pack(side=tk.LEFT, padx=5)

# Toggle Theme Button
toggle_button = create_button(button_frame, "Theme", toggle_theme)
toggle_button.pack(side=tk.LEFT, padx=5)

# Full Screen Toggle Button
fullscreen_button = create_button(button_frame, "Full Screen", toggle_fullscreen)
fullscreen_button.pack(side=tk.LEFT, padx=5)

# Status bar
status_var = tk.StringVar()
status_var.set("Welcome to SCALE FINDER!")
status_bar = tk.Label(window, textvariable=status_var, font=("Ubuntu Medium", 10), bd=1, relief=tk.SUNKEN, anchor=tk.W, padx=5)
status_bar.pack(side=tk.BOTTOM, fill=tk.X)

# Footer for credits
footer = tk.Label(window, text="**Made By Skyd 6ix**", font=("Mistral", 15), fg="green")
footer.pack(side=tk.BOTTOM, pady=10)

# Start animating the "Show Scale" button
# animate_button(show_scale_button)

# Run the application
window.mainloop()
