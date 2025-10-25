import type { UserModel } from "../../models/UserModel";

interface UserInfoProps {
  user: UserModel;
}

export function UserInfo({ user }: UserInfoProps) {
  const p = user.personal_info;
  const id = user.identification;

  return (
    <div className="p-4 bg-white shadow rounded-lg space-y-2">
      <h2 className="text-lg font-bold text-indigo-700">{p.full_name}</h2>
      <p>
        <strong>Email:</strong> {p.email}
      </p>
      <p>
        <strong>SĐT:</strong> {p.tel}
      </p>
      <p>
        <strong>Giới tính:</strong> {p.gender}
      </p>
      <p>
        <strong>Ngày sinh:</strong> {p.date_of_birth}
      </p>
      <p>
        <strong>Địa chỉ:</strong> {p.address.street}, {p.address.ward},{" "}
        {p.address.district}, {p.address.city}
      </p>
      <p>
        <strong>CMND/CCCD:</strong> {id.id_number}
      </p>
      <p>
        <strong>Ngày cấp:</strong> <strong>Ngày cấp:</strong>{" "}
        {id?.issue_date
          ? new Date(id.issue_date).toLocaleDateString("vi-VN")
          : "—"}
      </p>
      <p>
        <strong>Nơi cấp:</strong> {id.issue_place || "—"}
      </p>
    </div>
  );
}
