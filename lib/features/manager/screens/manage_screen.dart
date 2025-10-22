import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visit_tracker_app/features/manager/screens/client_details_screen.dart';

// --- DIALOG WIDGET ---
class _AddVisitDialog extends StatefulWidget {
  const _AddVisitDialog();

  @override
  State<_AddVisitDialog> createState() => _AddVisitDialogState();
}

class _AddVisitDialogState extends State<_AddVisitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveItinerary() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New itinerary added to unassigned visits.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Itinerary'),
      content: SizedBox(
        width: double.maxFinite,
        height: 380, // Slightly increased height to accommodate spacing
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _clientNameController,
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a client name' : null,
                ),
                // --- FIX: Added Spacing ---
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactPersonController,
                  decoration: const InputDecoration(labelText: 'Contact Person'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a contact person' : null,
                ),
                // --- FIX: Added Spacing ---
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location / Address'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a location' : null,
                ),
                // --- FIX: Added Spacing ---
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    _selectedDate == null
                        ? 'Select Visit Date'
                        : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                  onTap: _pickDate,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _saveItinerary,
          child: const Text('Save'),
        ),
      ],
    );
  }
}


// --- MAIN MANAGE SCREEN WIDGET (UNCHANGED) ---
class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  DateTime _currentMonth = DateTime.now();

  final DateTime _highPriorityDate = DateTime.now().add(const Duration(days: 2));
  final DateTime _scheduledDate = DateTime.now().add(const Duration(days: 5));
  final DateTime _completedDate = DateTime.now().subtract(const Duration(days: 3));

  void _showAddItineraryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const _AddVisitDialog();
      },
    );
  }

  void _showScheduleForDate(BuildContext context, int day) {
    final tappedDate = DateTime(_currentMonth.year, _currentMonth.month, day);

    if (tappedDate.day != _scheduledDate.day || tappedDate.month != _scheduledDate.month) {
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule for ${DateFormat.yMMMd().format(tappedDate)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildScheduleEntry(
                'Anuj Sharma',
                'Apollo Clinic',
                '11:00 AM',
                Colors.cyan,
              ),
              const Divider(),
              _buildScheduleEntry(
                'Deepika Padukone',
                'Apollo Clinic',
                '02:30 PM',
                Colors.purple,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleEntry(String name, String client, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Visiting: $client'),
            ],
          ),
          const Spacer(),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDummyCalendarGrid() {
    final daysOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final daysInMonth = List.generate(31, (index) => index + 1);

    return Container(
      height: 280,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek
                .map((day) =>
                    Text(day, style: const TextStyle(fontWeight: FontWeight.bold)))
                .toList(),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: daysInMonth.length,
              itemBuilder: (context, index) {
                final day = daysInMonth[index];
                Color? dotColor;

                if (day == _highPriorityDate.day) {
                  dotColor = Colors.red;
                } else if (day == _scheduledDate.day) {
                  dotColor = Colors.blue;
                } else if (day == _completedDate.day) {
                  dotColor = Colors.green;
                }

                return GestureDetector(
                  onTap: () => _showScheduleForDate(context, day),
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: day == DateTime.now().day
                                ? Colors.indigo[100]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontWeight: day == DateTime.now().day
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (dotColor != null)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showVisitDetailsPopup(BuildContext context, String clientName, String contactPerson, String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(clientName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow(Icons.person_outline, 'Contact Person', contactPerson),
                _buildDetailRow(Icons.location_on_outlined, 'Location', location),
                _buildDetailRow(Icons.phone_outlined, 'Phone', '+91 XXXXX XXXXX'),
                _buildDetailRow(Icons.notes_outlined, 'Notes', 'Requires follow-up on pricing.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Assign'),
              onPressed: () {
                Navigator.of(context).pop();
                _showAssignDialog(context);
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showAssignDialog(BuildContext context) {
    final teamMembers = ['Anuj Sharma', 'Deepika Padukone', 'Shah Rukh Khan'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Visit To'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(teamMembers[index]),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Visit assigned to ${teamMembers[index]}')),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
             TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDummyVisitTile(BuildContext context, String clientName, String contactPerson, String location) {
    return ListTile(
      title: Text(clientName),
      subtitle: Text('Contact: $contactPerson'),
      trailing: OutlinedButton(
        onPressed: () {
          _showVisitDetailsPopup(context, clientName, contactPerson, location);
        },
        child: const Text('Itinerary'),
      ),
    );
  }

  Widget _buildDummyClientTile(BuildContext context, String name, String location) {
    return ListTile(
      leading: const Icon(Icons.business_outlined),
      title: Text(name),
      subtitle: Text(location),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClientDetailsScreen(clientName: name, clientLocation: location),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Itinerary & Clients'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            tooltip: 'Add New Visit',
            onPressed: _showAddItineraryDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Unassigned Visits'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildDummyVisitTile(context, 'New Lead - MedCorp', 'Mr. Verma', 'Lower Parel'),
                const Divider(height: 1),
                _buildDummyVisitTile(context, 'Urgent Request - Lifeline', 'Ms. Desai', 'Goregaon East'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Team Calendar'),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1)),
                          icon: const Icon(Icons.chevron_left)),
                      Text(
                        DateFormat('MMMM yyyy').format(_currentMonth),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1)),
                          icon: const Icon(Icons.chevron_right)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDummyCalendarGrid(),
                  const SizedBox(height: 8),
                  const Text('Tap a date to see schedule',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Clients'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildDummyClientTile(context, 'Apollo Clinic', 'Andheri West'),
                const Divider(height: 1),
                _buildDummyClientTile(context, 'Max Healthcare', 'Bandra'),
                const Divider(height: 1),
                _buildDummyClientTile(context, 'Fortis Hospital', 'Mulund'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View All Clients'),
            ),
          ),
        ],
      ),
    );
  }
}