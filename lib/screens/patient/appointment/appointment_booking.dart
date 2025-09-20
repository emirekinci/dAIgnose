import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/services/appointment_service.dart';
import 'package:grad_project/utils/util.dart';

class AppointmentBooking extends StatefulWidget {
  final Doctor doctor;
  final String clinicType;
  final Hospital hospital;

  const AppointmentBooking({
    super.key,
    required this.doctor,
    required this.clinicType,
    required this.hospital,
  });

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  late List<DateTime> next7Days;
  late List<DateTime> bookedAppointments;

  static const themeColor = Colors.red;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generateNext7Days();
    _loadBookedAppointments();
  }

  void generateNext7Days() {
    DateTime today = DateTime.now();

    if (today.hour >= 17) {
      today = today.add(Duration(days: 1));
    }

    List<DateTime> weekdays = [];
    int added = 0;
    DateTime current = today;

    while (weekdays.length < 7) {
      if (current.weekday >= DateTime.monday &&
          current.weekday <= DateTime.friday) {
        weekdays.add(current);
      }
      added++;
      current = today.add(Duration(days: added));
    }

    next7Days = weekdays;
  }

  String _getWeekdayName(int weekday) {
    final l10n = AppLocalizations.of(context)!;
    switch (weekday) {
      case DateTime.monday:
        return l10n.monday;
      case DateTime.tuesday:
        return l10n.tuesday;
      case DateTime.wednesday:
        return l10n.wednesday;
      case DateTime.thursday:
        return l10n.thursday;
      case DateTime.friday:
        return l10n.friday;
      case DateTime.saturday:
        return l10n.saturday;
      case DateTime.sunday:
        return l10n.sunday;
      default:
        return "";
    }
  }

  Future<void> _loadBookedAppointments() async {
    final appointments = await AppointmentService().fetchBookedAppointments(
      widget.doctor.id,
    );

    if (!mounted) return;

    setState(() {
      bookedAppointments = appointments;
      isLoading = false;
    });
  }

  List<TimeOfDay> generateTimeSlots() {
    final startHour = 9;
    final endHour = 17;
    final interval = 30;

    List<TimeOfDay> slots = [];

    for (int hour = startHour; hour < endHour; hour++) {
      slots.add(TimeOfDay(hour: hour, minute: 0));
      slots.add(TimeOfDay(hour: hour, minute: interval));
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 65.0),
                  Text(
                    "Dr. ${widget.doctor.name}\n${widget.clinicType.localizeClinicType(context)}",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: next7Days.length,
                      itemBuilder: (context, index) {
                        final day = next7Days[index];
                        final formattedDate =
                            "${day.day}.${day.month}.${day.year} (${_getWeekdayName(day.weekday)})";
                        final now = DateTime.now();

                        final filteredTimeSlots =
                            generateTimeSlots().where((slot) {
                              final slotDateTime = DateTime(
                                day.year,
                                day.month,
                                day.day,
                                slot.hour,
                                slot.minute,
                              );

                              return slotDateTime.isAfter(now);
                            }).toList();

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children:
                                        filteredTimeSlots.map((slot) {
                                          final slotDateTime = DateTime(
                                            day.year,
                                            day.month,
                                            day.day,
                                            slot.hour,
                                            slot.minute,
                                          );

                                          final isBooked = bookedAppointments
                                              .any(
                                                (booked) =>
                                                    booked.year ==
                                                        slotDateTime.year &&
                                                    booked.month ==
                                                        slotDateTime.month &&
                                                    booked.day ==
                                                        slotDateTime.day &&
                                                    booked.hour ==
                                                        slotDateTime.hour &&
                                                    booked.minute ==
                                                        slotDateTime.minute,
                                              );

                                          final timeString = slot.format(
                                            context,
                                          );

                                          return SizedBox(
                                            width: 120,
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed:
                                                  isBooked
                                                      ? null
                                                      : () async {
                                                        final confirm = await showDialog<
                                                          bool
                                                        >(
                                                          context: context,
                                                          builder:
                                                              (
                                                                context,
                                                              ) => AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                title: Text(
                                                                  AppLocalizations.of(
                                                                    context,
                                                                  )!.appointment_confirmation,
                                                                ),
                                                                content: Text(
                                                                  "${AppLocalizations.of(context)!.appointment_confirmation_text} ${slotDateTime.day}/${slotDateTime.month} (${_getWeekdayName(slotDateTime.weekday)}) - $timeString",
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Navigator.pop(
                                                                          context,
                                                                          false,
                                                                        ),
                                                                    child: Text(
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.cancel,
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                    ),
                                                                    onPressed:
                                                                        () => Navigator.pop(
                                                                          context,
                                                                          true,
                                                                        ),
                                                                    child: Text(
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.confirm,
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        );

                                                        if (confirm == true) {
                                                          bool
                                                          hasAnotherAppointment =
                                                              await AppointmentService()
                                                                  .hasAnotherInSameClinic(
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                    widget
                                                                        .clinicType,
                                                                  );

                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          if (hasAnotherAppointment) {
                                                            final result = await showDialog<
                                                              bool
                                                            >(
                                                              context: context,
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    title: Text(
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.current_appointment,
                                                                    ),
                                                                    content: Text(
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.already_have_appointment_text,
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () => Navigator.of(
                                                                              context,
                                                                            ).pop(
                                                                              false,
                                                                            ),
                                                                        child: Text(
                                                                          AppLocalizations.of(
                                                                            context,
                                                                          )!.no,
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                        ),
                                                                        onPressed:
                                                                            () => Navigator.pop(
                                                                              context,
                                                                              true,
                                                                            ),
                                                                        child: Text(
                                                                          AppLocalizations.of(
                                                                            context,
                                                                          )!.yes_cancel,
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                            if (result ==
                                                                true) {
                                                              await AppointmentService().bookAppointment(
                                                                hasAnotherAppointment:
                                                                    true,
                                                                patientId:
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                clinicType:
                                                                    widget
                                                                        .clinicType,
                                                                doctorId:
                                                                    widget
                                                                        .doctor
                                                                        .id,
                                                                doctorName:
                                                                    widget
                                                                        .doctor
                                                                        .name,
                                                                hospitalId:
                                                                    widget
                                                                        .hospital
                                                                        .id,
                                                                date:
                                                                    slotDateTime,
                                                              );

                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }

                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    AppLocalizations.of(
                                                                      context,
                                                                    )!.info_appointment_updated,
                                                                  ),
                                                                ),
                                                              );

                                                              Navigator.popUntil(
                                                                context,
                                                                (route) =>
                                                                    route
                                                                        .isFirst,
                                                              );
                                                            }
                                                          } else {
                                                            await AppointmentService().bookAppointment(
                                                              patientId:
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                              clinicType:
                                                                  widget
                                                                      .clinicType,
                                                              doctorId:
                                                                  widget
                                                                      .doctor
                                                                      .id,
                                                              doctorName:
                                                                  widget
                                                                      .doctor
                                                                      .name,
                                                              hospitalId:
                                                                  widget
                                                                      .hospital
                                                                      .id,
                                                              date:
                                                                  slotDateTime,
                                                            );

                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  AppLocalizations.of(
                                                                    context,
                                                                  )!.info_appointment_booked,
                                                                ),
                                                              ),
                                                            );

                                                            Navigator.popUntil(
                                                              context,
                                                              (route) =>
                                                                  route.isFirst,
                                                            );
                                                          }
                                                        }
                                                      },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    isBooked
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                timeString,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
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
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
