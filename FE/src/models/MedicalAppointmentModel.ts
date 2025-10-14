// Doctor Info
export interface DoctorInfo {
  doctor_id: string;
  doctor_name: string;
  specialization: string;
  department: string;
  phone: string;
}

export const defaultDoctorInfo: DoctorInfo = {
  doctor_id: "",
  doctor_name: "",
  specialization: "",
  department: "",
  phone: "",
};

// Medical Appointment Model
export interface MedicalAppointmentModel {
  _id: string;
  appointment_id: string;
  user_id: string;
  hospital_name: string;
  department: string;
  doctor_info: DoctorInfo;
  appointment_date: string; // ISO string
  appointment_time: string;
  appointment_type: string;
  reason: string;
  status: string;
  actual_check_in?: string | null;
  check_in_face_verified: boolean;
  payment_status: string;
  total_cost: number;
  is_emergency: boolean;
  created_at: string;
}

export const defaultMedicalAppointment: MedicalAppointmentModel = {
  _id: "",
  appointment_id: "",
  user_id: "",
  hospital_name: "",
  department: "",
  doctor_info: defaultDoctorInfo,
  appointment_date: "",
  appointment_time: "",
  appointment_type: "",
  reason: "",
  status: "",
  actual_check_in: null,
  check_in_face_verified: false,
  payment_status: "",
  total_cost: 0,
  is_emergency: false,
  created_at: "",
};

// ✅ Parse function (từ JSON về model)
export const parseMedicalAppointment = (
  json: any
): MedicalAppointmentModel => ({
  _id: json._id ?? "",
  appointment_id: json.appointment_id ?? "",
  user_id: json.user_id ?? "",
  hospital_name: json.hospital_name ?? "",
  department: json.department ?? "",
  doctor_info: {
    doctor_id: json.doctor_info?.doctor_id ?? "",
    doctor_name: json.doctor_info?.doctor_name ?? "",
    specialization: json.doctor_info?.specialization ?? "",
    department: json.doctor_info?.department ?? "",
    phone: json.doctor_info?.phone ?? "",
  },
  appointment_date: json.appointment_date ?? "",
  appointment_time: json.appointment_time ?? "",
  appointment_type: json.appointment_type ?? "",
  reason: json.reason ?? "",
  status: json.status ?? "",
  actual_check_in: json.actual_check_in ?? null,
  check_in_face_verified: json.check_in_face_verified ?? false,
  payment_status: json.payment_status ?? "",
  total_cost: Number(json.total_cost ?? 0),
  is_emergency: json.is_emergency ?? false,
  created_at: json.created_at ?? "",
});

// ✅ Optional: Convert model -> JSON (nếu cần gửi về API)
export const toJsonMedicalAppointment = (
  model: MedicalAppointmentModel
): any => ({
  _id: model._id,
  appointment_id: model.appointment_id,
  user_id: model.user_id,
  hospital_name: model.hospital_name,
  department: model.department,
  doctor_info: model.doctor_info,
  appointment_date: model.appointment_date,
  appointment_time: model.appointment_time,
  appointment_type: model.appointment_type,
  reason: model.reason,
  status: model.status,
  actual_check_in: model.actual_check_in,
  check_in_face_verified: model.check_in_face_verified,
  payment_status: model.payment_status,
  total_cost: model.total_cost,
  is_emergency: model.is_emergency,
  created_at: model.created_at,
});
