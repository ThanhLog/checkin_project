// Address
export interface Address {
  street: string;
  ward: string;
  district: string;
  city: string;
}

export const defaultAddress: Address = {
  street: "",
  ward: "",
  district: "",
  city: "",
};

// Personal Info
export interface PersonalInfo {
  full_name: string;
  tel: string;
  email: string;
  date_of_birth: string;
  gender: string;
  address: Address;
}

export const defaultPersonalInfo: PersonalInfo = {
  full_name: "",
  tel: "",
  email: "",
  date_of_birth: "",
  gender: "",
  address: defaultAddress,
};

// Identification
export interface Identification {
  id_number: string;
  issue_date?: string;
  issue_place: string;
}

export const defaultIdentification: Identification = {
  id_number: "",
  issue_date: "",
  issue_place: "",
};

// Face Data
export interface FaceData {
  face_image_url?: string;
  embedding_version?: string;
  embeddings?: string[];
}

export const defaultFaceData: FaceData = {
  face_image_url: "",
  embedding_version: "",
  embeddings: [],
};

// Face Image
export interface FaceImage {
  image_url?: string;
  image_type?: string;
  uploaded_at?: string;
  file_size?: number;
  file_format?: string;
}

export const defaultFaceImage: FaceImage = {
  image_url: "",
  image_type: "",
  uploaded_at: "",
  file_size: 0,
  file_format: "",
};

// User Model
export interface UserModel {
  _id: string;
  user_id: string;
  personal_info: PersonalInfo;
  identification: Identification;
  face_data: FaceData;
  images: FaceImage[];
}

export const defaultUserModel: UserModel = {
  _id: "",
  user_id: "",
  personal_info: defaultPersonalInfo,
  identification: defaultIdentification,
  face_data: defaultFaceData,
  images: [],
};

// Utility parser functions
export const parseUserModel = (json: any): UserModel => ({
  _id: json._id ?? "",
  user_id: json.user_id ?? "",
  personal_info: {
    full_name: json.personal_info?.full_name ?? "",
    tel: json.personal_info?.tel ?? "",
    email: json.personal_info?.email ?? "",
    date_of_birth: json.personal_info?.date_of_birth ?? "",
    gender: json.personal_info?.gender ?? "",
    address: {
      street: json.personal_info?.address?.street ?? "",
      ward: json.personal_info?.address?.ward ?? "",
      district: json.personal_info?.address?.district ?? "",
      city: json.personal_info?.address?.city ?? "",
    },
  },
  identification: {
    id_number: json.identification?.id_number ?? "",
    issue_date: json.identification?.issue_date ?? "",
    issue_place: json.identification?.issue_place ?? "",
  },
  face_data: {
    face_image_url: json.face_data?.face_image_url ?? "",
    embedding_version: json.face_data?.embedding_version ?? "",
    embeddings: json.face_data?.embeddings ?? [],
  },
  images:
    json.images?.map((img: any) => ({
      image_url: img.image_url ?? "",
      image_type: img.image_type ?? "",
      uploaded_at: img.uploaded_at ?? "",
      file_size: img.file_size ?? 0,
      file_format: img.file_format ?? "",
    })) ?? [],
});
