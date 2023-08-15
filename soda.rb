require 'gtk3' # Require 'gtk3' - This imports the GTK3 library, which will be used to create our GUI.
require 'date' # Adding this to use the Date class.
# --- Basic Structure and Initialization ---

class SodaFreeCounter
  def read_start_date_from_file
    date_str = File.read(@file_path).chomp
    Date.parse(date_str) if valid_date_format?(date_str)
  end

  def valid_date_format?(date_str)
    !!Date.parse(date_str)
  rescue Date::Error
    false
  end

  def initialize
    @file_path = "C:/Users/brand/OneDrive/Desktop/scrap/soda_free_date.txt"

    @start_date = File.exist?(@file_path) ? read_start_date_from_file : nil

    initialize_window
  end

  # --- Helper Functions ---

  # - days_soda_free returns the difference in days between the today and the last day you drank soda.
  def days_soda_free
    puts "Today's Date: #{Date.today}"
    puts "Start Date: #{@start_date}"

    difference = (Date.today - @start_date).to_i

    # No need for .abs here. If the value is negative, it should be a clear indication of an issue.
    difference
  end


  # - save_date will save the provided date to the file and updates the @start_date variable.
  def save_date(date)
    File.write(@file_path, date.to_s)
    @start_date = date
  end

  # --- Updating the UI ---

  # - reset_counter: This is called when the "Set Last Soda Date" button is clicked
  # It fetches the selected date from the calender and then saves it using 'save_Date' - then updates to reflect the change.
  def reset_counter
    year, month, day = @calendar.date

    puts "Calendar values - Year: #{year}, Month: #{month}, Day: #{day}"

    date = Date.new(year, month, day)

    puts "Parsed Date: #{date}"

    if date == Date.today
      save_date(date)
      update_label
    elsif date > Date.today
      # Informing the user that the date cannot be in the future.
      @label.text = "Error: The date cannot be in the future."
    else
      save_date(date)
      update_label
    end
  end


  #update_label - Updates the main label on the window to show how many days you've been soda-free.
  # If no date is set (i.e, @start_Date is nil) it will then ask the user to set a date.
  def update_label
    if @start_date
      @label.text = "You last drank soda on #{@start_date}. \nYou have been soda-free for #{days_soda_free} days!"
    else
      @label.text = "Please set the date you last drank soda using the calendar below."
    end
  end

  # --- Building the Graphical User Interface ---
  # initialize_window: This method sets up the main window of the application.
  # It creates the window, sets its size, and defines what should happen when you close it (it quits the application).
  # A vertical vbox is created to hold the different elements vertically aligned.
  # @label is where the main text is displayed.
  # @calendar allows the user to pick a date.
  # he button, when clicked, will reset the soda-free counter to the selected date on the calendar.
  # pack_start is used to add these elements to the box, and then the box is added to the main window.
  # window.show_all displays the entire window and all its components.
  # Lastly, update_label is called to ensure the label has the right text on startup.

  def initialize_window
    window = Gtk::Window.new('Soda-Free Counter')
    window.set_size_request(400, 250)
    window.signal_connect('destroy') { Gtk.main_quit }

    vbox = Gtk::Box.new(:vertical, 6)
    @label = Gtk::Label.new('')

    @calendar = Gtk::Calendar.new
    button = Gtk::Button.new(label: 'Set Last Soda Date')
    button.signal_connect('clicked') { reset_counter }

    vbox.pack_start(@label, expand: true, fill: true, padding: 10)
    vbox.pack_start(@calendar, expand: true, fill: true, padding: 10)
    vbox.pack_start(button, expand: true, fill: true, padding: 10)

    window.add(vbox)
    window.show_all

    update_label
  end
end


# --- Running the Application ---
Gtk.init # initializes GTK.
SodaFreeCounter.new # - SodaFreeCounter.new: Creates an instance of our SodaFreeCounter class, which in turn initializes the window and the UI.
Gtk.main # - Gtk.main: Starts the main loop of the application, allowing user interaction.

