import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import ServiceSelect from "./pages/ServiceSelect";
import HotelBooking from "./pages/hotel/HotelBooking";
import HospitalBooking from "./pages/hospital/HospitalBooking";
import { HotelLogin } from "./pages/hotel/HoteLogin";
import { HospitalLogin } from "./pages/hospital/HospitalLogin";

const AppRouter = () => (
  <Router>
    <Routes>
      <Route path="/" element={<ServiceSelect />} />
      {/* Hotel Admin Booking */}
      <Route path="/login/hotel" element={<HotelLogin />} />
      <Route path="/checkin/hotel" element={<HotelBooking />} />

      {/* Hospital Admin Booking */}
      <Route path="/login/hospital" element={<HospitalLogin />} />
      <Route path="/checkin/hospital" element={<HospitalBooking />} />
    </Routes>
  </Router>
);

export default AppRouter;
