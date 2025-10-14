export interface RoomInfo {
  room_number: string;
  room_type: string;
  floor: number;
  bed_type: string;
  max_guests: number;
  price_per_night: number;
}

export interface HotelBookingModel {
  _id: string;
  booking_id: string;
  user_id: string;
  hotel_name: string;
  room_info: RoomInfo;
  check_in_date: string; // ISO string
  check_out_date: string; // ISO string
  actual_check_in?: string; // optional
  actual_check_out?: string; // optional
  status: string;
  payment_status: string;
  total_amount: number;
  check_in_face_verified: boolean;
  check_out_face_verified: boolean;
  created_at: string;
}
