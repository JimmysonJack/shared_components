import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

class PermissionController extends GetxController {
  final checkboxValue = false.obs;
  final permissionList = [].obs;
  final selectedPermission = [].obs;

  final onLoad = false.obs;
  final changeDetected = false.obs;

  List<Map<String, dynamic>> _authorities = [
    {"authority": "ACCESS_BILLS"},
    {"authority": "ACCESS_EMERGENCY"},
    {"authority": "ACCESS_FACILITY_MANAGEMENT"},
    {"authority": "ACCESS_IPD"},
    {"authority": "ACCESS_LABORATORY"},
    {"authority": "ACCESS_MORTUARY"},
    {"authority": "ACCESS_NURSING_CARE"},
    {"authority": "ACCESS_OPD"},
    {"authority": "ACCESS_PHARMACY"},
    {"authority": "ACCESS_RADIOLOGY"},
    {"authority": "ACCESS_REGISTRATION"},
    {"authority": "ACCESS_REPORT"},
    {"authority": "ACCESS_SOCIAL_WELFARE"},
    {"authority": "ACCESS_SPECIAL_CLINICS"},
    {"authority": "ACCESS_STORE"},
    {"authority": "ACCESS_THEATER"},
    {"authority": "ACCESS_USER_MANAGEMENT"},
    {"authority": "APPROVE_DISCHARGE_ORDER"},
    {"authority": "APPROVE_LAB_ORDER_TEST_RESULT"},
    {"authority": "APPROVE_RADIOLOGY_ORDER_RESULT"},
    {"authority": "ASSIGN_NURSE_TO_WARD"},
    {"authority": "ASSIGN_REMOVE_USER_FROM_STORE"},
    {"authority": "ASSIGN_USER_ROLES"},
    {"authority": "CANCEL_BILL"},
    {"authority": "CANCEL_PENDING_SERVICE_ORDER"},
    {"authority": "CANCEL_SERVICE_ORDER"},
    {"authority": "CHANGE_DISPENSING_PHARMARCY"},
    {"authority": "CHANGE_PATIENT_MEDICATION"},
    {"authority": "CHANGE_THEATRE"},
    {"authority": "CHANGE_VISIT_CSG"},
    {"authority": "COLLECT_SAMPLE"},
    {"authority": "CONFIRM_PROCEDURE_CHECKLIST"},
    {"authority": "CONFIRM_RECEIVING_ISSUED_ITEMS"},
    {"authority": "CONFIRM_RECEIVING_PATIENT_MEDICATION"},
    {"authority": "CONFIRM_STOCK_RECEIVING"},
    {"authority": "CREATE_ADMISSION_ORDER"},
    {"authority": "CREATE_APPOINTMENT"},
    {"authority": "CREATE_BED"},
    {"authority": "CREATE_BED_TYPE"},
    {"authority": "CREATE_BILL"},
    {"authority": "CREATE_CABINET"},
    {"authority": "CREATE_CABINET_DOOR"},
    {"authority": "CREATE_CLERK_SHEET"},
    {"authority": "CREATE_CLERK_SHEET_TYPE"},
    {"authority": "CREATE_CLERK_SHEET_TYPE_CHILD"},
    {"authority": "CREATE_CLIENT"},
    {"authority": "CREATE_CLIENT_ADMISSION"},
    {"authority": "CREATE_COMPLAINT"},
    {"authority": "CREATE_COMPLAINT_CONVERSATION"},
    {"authority": "CREATE_CONFIRMED_DIAGNOSIS"},
    {"authority": "CREATE_CONSENT_FORM"},
    {"authority": "CREATE_CONSERVATIVE_MANAGEMENT"},
    {"authority": "CREATE_CONSULTATION_ROOM"},
    {"authority": "CREATE_CORPES_ADMISSION"},
    {"authority": "CREATE_CORPSE"},
    {"authority": "CREATE_CORPSE_SERVICE"},
    {"authority": "CREATE_CORPSE_VERIFICATION"},
    {"authority": "CREATE_COST_SHARING_GROUP"},
    {"authority": "CREATE_COST_SHARING_GROUP_DEPENDENCY"},
    {"authority": "CREATE_DECEASED_ADMTD_CLNT"},
    {"authority": "CREATE_DECEASED_CLNT_VERIFICATION"},
    {"authority": "CREATE_DEPOSIT_BILL"},
    {"authority": "CREATE_DISCHARGE_ORDER"},
    {"authority": "CREATE_DISPENSED_ITEM"},
    {"authority": "CREATE_EQUIPMENT"},
    {"authority": "CREATE_EQUIPMENT_IMAGING_TEST"},
    {"authority": "CREATE_EQUIPMENT_TEST"},
    {"authority": "CREATE_EQUIPMENT_TYPE"},
    {"authority": "CREATE_EXEMPTION_ACCESS"},
    {"authority": "CREATE_FACILITY_DEPARTMENT"},
    {"authority": "CREATE_FACILITY_ENTRY_ITEM"},
    {"authority": "CREATE_FACILITY_EQUIPMENT"},
    {"authority": "CREATE_FACILITY_ITEM"},
    {"authority": "CREATE_IMAGING_TEST"},
    {"authority": "CREATE_INPUT_FORM"},
    {"authority": "CREATE_INSURANCE_API_CREDENTIALS"},
    {"authority": "CREATE_INVESTIGATION_REFERAL"},
    {"authority": "CREATE_INVESTIGATION_REFERAL_RESULT"},
    {"authority": "CREATE_ISSUING"},
    {"authority": "CREATE_ITEM"},
    {"authority": "CREATE_ITEM_PRICE"},
    {"authority": "CREATE_ITEM_RECEIVING"},
    {"authority": "CREATE_ITEM_REQUISITION"},
    {"authority": "CREATE_LAB_ORDER"},
    {"authority": "CREATE_LAB_ORDER_TEST_RESULT"},
    {"authority": "CREATE_LAB_TEST"},
    {"authority": "CREATE_MEDICAL_SUPPLY"},
    {"authority": "CREATE_MORTUARY_ORDER"},
    {"authority": "CREATE_NURSE_PRESCRIPTION_RECORD"},
    {"authority": "CREATE_NURSING_PLAN"},
    {"authority": "CREATE_OCCURANCE"},
    {"authority": "CREATE_OCCURANCE_TYPE"},
    {"authority": "CREATE_OPERATION_FACILITY_ITEM"},
    {"authority": "CREATE_OUTPUT_FORM"},
    {"authority": "CREATE_PATIENT_MEDICATION_USAGE"},
    {"authority": "CREATE_PHYSICAL_COUNTS"},
    {"authority": "CREATE_PHYSICAL_COUNT_USER"},
    {"authority": "CREATE_POST_ANAESTHETIC_SETTING"},
    {"authority": "CREATE_PRE_OPERATIONAL_CONDITION"},
    {"authority": "CREATE_PRISCRIPTION"},
    {"authority": "CREATE_PROCEDURE"},
    {"authority": "CREATE_PROCEDURE_CHECKLIST_ITEMS"},
    {"authority": "CREATE_PROCEDURE_HISTORIES"},
    {"authority": "CREATE_PROCEDURE_POST_ANAESTHETIC"},
    {"authority": "CREATE_PROVISSIONAL_DIAGNOSIS"},
    {"authority": "CREATE_QUESTION_ANSWERS"},
    {"authority": "CREATE_RADIOLOGY_ORDER"},
    {"authority": "CREATE_RADIOLOGY_ORDER_RESULT"},
    {"authority": "CREATE_REORDER_LEVEL"},
    {"authority": "CREATE_REQUISITION"},
    {"authority": "CREATE_SAMPLE"},
    {"authority": "CREATE_SAMPLE_REJECTION_REASON"},
    {"authority": "CREATE_SAMPLE_TYPE"},
    {"authority": "CREATE_SERVICE_ORDERS"},
    {"authority": "CREATE_STOCK_RECEIVING"},
    {"authority": "CREATE_STORE"},
    {"authority": "CREATE_STORE_ACCESS"},
    {"authority": "CREATE_STORE_TO_STORE_ACCESS"},
    {"authority": "CREATE_SUB_DEPARTMENT"},
    {"authority": "CREATE_SUB_DEPARTMENT_ACCESS"},
    {"authority": "CREATE_SURGERY_TEAM"},
    {"authority": "CREATE_THEATRE"},
    {"authority": "CREATE_THEATRE_FACILITY_ITEMS"},
    {"authority": "CREATE_TRIAGE"},
    {"authority": "CREATE_TURNING_CHART"},
    {"authority": "CREATE_USER"},
    {"authority": "CREATE_USER_THEATRE"},
    {"authority": "CREATE_VENDOR"},
    {"authority": "CREATE_VERIFIED_PRISCRIPTION_ITEMS"},
    {"authority": "CREATE_VITAL_SIGN"},
    {"authority": "CREATE_WARD"},
    {"authority": "CREATE__DEPOSIT_BILL"},
    {"authority": "DELETE_BED"},
    {"authority": "DELETE_BED_TYPE"},
    {"authority": "DELETE_CABINET"},
    {"authority": "DELETE_CABINET_DOOR"},
    {"authority": "DELETE_CLERK_SHEET"},
    {"authority": "DELETE_CLERK_SHEET_TYPE"},
    {"authority": "DELETE_CLERK_SHEET_TYPE_CHILD"},
    {"authority": "DELETE_CLIENT_IDENTIFICATION"},
    {"authority": "DELETE_CONSULTATION_ROOM"},
    {"authority": "DELETE_CORPSE"},
    {"authority": "DELETE_CORPSE_SERVICE"},
    {"authority": "DELETE_COST_SHARING_GROUP"},
    {"authority": "DELETE_COST_SHARING_GROUP_DEPENDENCY"},
    {"authority": "DELETE_DISCHARGE_ORDER"},
    {"authority": "DELETE_EQUIPMENT"},
    {"authority": "DELETE_EQUIPMENT_IMAGING_TEST"},
    {"authority": "DELETE_EQUIPMENT_TEST"},
    {"authority": "DELETE_EQUIPMENT_TYPE"},
    {"authority": "DELETE_FACILITY_DEPARTMENT"},
    {"authority": "DELETE_FACILITY_ENTRY_ITEM"},
    {"authority": "DELETE_FACILITY_EQUIPMENT"},
    {"authority": "DELETE_FACILITY_ITEM"},
    {"authority": "DELETE_IMAGING_TEST"},
    {"authority": "DELETE_INPUT_FORM"},
    {"authority": "DELETE_ITEM"},
    {"authority": "DELETE_ITEM_PRICE"},
    {"authority": "DELETE_ITEM_RECEIVING"},
    {"authority": "DELETE_ITEM_REQUISITION"},
    {"authority": "DELETE_LAB_ORDER"},
    {"authority": "DELETE_LAB_TEST"},
    {"authority": "DELETE_MORTUARY_ORDER"},
    {"authority": "DELETE_NURSING_PLAN"},
    {"authority": "DELETE_OCCURANCE"},
    {"authority": "DELETE_OCCURANCE_TYPE"},
    {"authority": "DELETE_OPERATION_FACILITY_ITEM"},
    {"authority": "DELETE_OUTPUT_FORM"},
    {"authority": "DELETE_PHYSICAL_COUNT_USER"},
    {"authority": "DELETE_POST_ANAESTHETIC_SETTING"},
    {"authority": "DELETE_RADIOLOGY_ORDERS"},
    {"authority": "DELETE_REORDER_LEVEL"},
    {"authority": "DELETE_REQUISITION"},
    {"authority": "DELETE_SAMPLE"},
    {"authority": "DELETE_SAMPLE_REJECTION_REASON"},
    {"authority": "DELETE_SAMPLE_TYPE"},
    {"authority": "DELETE_STOCK_RECEIVING"},
    {"authority": "DELETE_STORE"},
    {"authority": "DELETE_SUB_DEPARTMENT"},
    {"authority": "DELETE_SURGERY_TEAM"},
    {"authority": "DELETE_THEATRE"},
    {"authority": "DELETE_THEATRE_FACILITY_ITEM"},
    {"authority": "DELETE_THEATRE_USER"},
    {"authority": "DELETE_TRIAGES"},
    {"authority": "DELETE_TURNING_CHART"},
    {"authority": "DELETE_VENDOR"},
    {"authority": "DELETE_VITAL_SIGN"},
    {"authority": "DELETE_WARD"},
    {"authority": "DISCHARGE_CORPES_ADMISSION"},
    {"authority": "DOWNLOAD_FACILITY_ITEM"},
    {"authority": "DOWNLOAD_ITEM_LIST"},
    {"authority": "DOWNLOAD_ITEM_PRICE"},
    {"authority": "EDIT_CLIENT"},
    {"authority": "EDIT_CLIENT_IDENTIFICATION"},
    {"authority": "EDIT_PROCEDURE"},
    {"authority": "END_VISIT"},
    {"authority": "EXTEND_VISIT"},
    {"authority": "FIND_IDENTITY_AND_IDENTITY_NUMBER"},
    {"authority": "READ_ATTACHMENT"},
    {"authority": "RECOLLECT_SAMPLE"},
    {"authority": "REJECT_SAMPLE"},
    {"authority": "REMOVE_STORE_TO_STORE_ACCESS"},
    {"authority": "REMOVE_SUB_DEPARTMENT_ACCESS_USER"},
    {"authority": "RESET_USER_PASSWORD"},
    {"authority": "RETURN_PATIENT_MEDICATION_TO_STORE"},
    {"authority": "START_APPOINTMENT_VISIT"},
    {"authority": "START_INVESTIGATION_REFERAL_REATTENDANCE"},
    {"authority": "START_VISIT"},
    {"authority": "STOP_MEDICATION_USE"},
    {"authority": "SUBMIT_REQUISITION_REQUEST"},
    {"authority": "TRANSFER_CLIENT_TO_ANOTHER_BED"},
    {"authority": "UPLOAD_FACILITY_ITEM"},
    {"authority": "UPLOAD_ITEMS"},
    {"authority": "UPLOAD_ITEM_PRICES"},
    {"authority": "VERIFY_BILL"},
    {"authority": "VIEW_ADDED_TO_LIST_PROCEDURES"},
    {"authority": "VIEW_ADMISSION_ORDERS"},
    {"authority": "VIEW_APPOINTMENTS"},
    {"authority": "VIEW_APPROVED_PROCEDURE"},
    {"authority": "VIEW_ASSIGNED_THEATRES"},
    {"authority": "VIEW_BEDS"},
    {"authority": "VIEW_BED_TYPES"},
    {"authority": "VIEW_BILLS"},
    {"authority": "VIEW_CABINETS"},
    {"authority": "VIEW_CABINET_DDORS"},
    {"authority": "VIEW_CABINET_WITH_FREE_CABDOORS"},
    {"authority": "VIEW_CANCELLED_PROCEDURES"},
    {"authority": "VIEW_CLERK_SHEET"},
    {"authority": "VIEW_CLERK_SHEET_TYPES"},
    {"authority": "VIEW_CLERK_SHEET_TYPE_CHILDREN"},
    {"authority": "VIEW_CLIENTS"},
    {"authority": "VIEW_CLIENT_ADMISSIONS"},
    {"authority": "VIEW_CLIENT_WITHOUT_SAMPLES"},
    {"authority": "VIEW_COMPLAINT_CONVERSATION"},
    {"authority": "VIEW_CONSENT_FORMS"},
    {"authority": "VIEW_CONSERVATIVE_MANAGEMENT"},
    {"authority": "VIEW_CONSULTATION_ROOMS"},
    {"authority": "VIEW_CONSULT_ANAESTHESIA_LIST"},
    {"authority": "VIEW_CORPES_ADMISSIONS"},
    {"authority": "VIEW_CORPSES"},
    {"authority": "VIEW_CORPSE_SERVICES"},
    {"authority": "VIEW_COST_SHARING_GROUPS"},
    {"authority": "VIEW_COST_SHARING_GROUP_DEPENDENCIE"},
    {"authority": "VIEW_DEPARTMENTS"},
    {"authority": "VIEW_DEPOSIT_BILL"},
    {"authority": "VIEW_DIAGNOSIS"},
    {"authority": "VIEW_DIAGNOSIS_CATEGORIES"},
    {"authority": "VIEW_DISCHARGE_ORDERS"},
    {"authority": "VIEW_DISPENSING_VERIFICATION_QUEUE"},
    {"authority": "VIEW_DOSAGES"},
    {"authority": "VIEW_DRAFT_PROCEDURES"},
    {"authority": "VIEW_ENDED_PROCEDURES"},
    {"authority": "VIEW_EQUIPMENTS"},
    {"authority": "VIEW_EQUIPMENT_IMAGING_TESTS"},
    {"authority": "VIEW_EQUIPMENT_TESTS"},
    {"authority": "VIEW_EQUIPMENT_TYPES"},
    {"authority": "VIEW_EXEMPTION_ACCESSES"},
    {"authority": "VIEW_FACILITY_BILLS"},
    {"authority": "VIEW_FACILITY_BILLS_SUMMARY"},
    {"authority": "VIEW_FACILITY_BILL_COST_SHARING_GROUPS"},
    {"authority": "VIEW_FACILITY_CLIENT_ATTENDANCE_SUMMARY"},
    {"authority": "VIEW_FACILITY_COMPLAINTS"},
    {"authority": "VIEW_FACILITY_DEPARTMENTS"},
    {"authority": "VIEW_FACILITY_DISPENSING_QUEUE"},
    {"authority": "VIEW_FACILITY_EQUIPMENTS"},
    {"authority": "VIEW_FACILITY_INSURANCE_CONFIGURATIONS"},
    {"authority": "VIEW_FACILITY_ITEMS"},
    {"authority": "VIEW_FACILITY_MHIS_CLAIMS"},
    {"authority": "VIEW_FACILITY_MHIS_CLAIMS_SUMMARY"},
    {"authority": "VIEW_FACILITY_USERS"},
    {"authority": "VIEW_FACILITY_USER_PERFORMANCE"},
    {"authority": "VIEW_IMAGING_TESTS"},
    {"authority": "VIEW_INPUT_FORMS"},
    {"authority": "VIEW_INSURANCE_CARD_DETAILS"},
    {"authority": "VIEW_INVESTIGATION_REFERAL"},
    {"authority": "VIEW_INVESTIGATION_REFERAL_QUEU"},
    {"authority": "VIEW_ISSUING"},
    {"authority": "VIEW_ISSUING_ITEMS"},
    {"authority": "VIEW_ITEMS"},
    {"authority": "VIEW_ITEM_PRICES"},
    {"authority": "VIEW_LAB_ORDERS"},
    {"authority": "VIEW_LAB_TESTS"},
    {"authority": "VIEW_LAB_TEST_RESULTS"},
    {"authority": "VIEW_MORTUARY_ORDERS"},
    {"authority": "VIEW_MY_REPORTED_COMPLAINTS"},
    {"authority": "VIEW_NURSE_PRESCRIPTION_RECORDs"},
    {"authority": "VIEW_NURSING_PLANS"},
    {"authority": "VIEW_OCCURANCES"},
    {"authority": "VIEW_OCCURANCE_TYPES"},
    {"authority": "VIEW_OPERATION_FACILITY_ITEMS"},
    {"authority": "VIEW_OUTPUT_FORM"},
    {"authority": "VIEW_PATIENT_MEDICATION_USE"},
    {"authority": "VIEW_PHYSICAL_COUNTS"},
    {"authority": "VIEW_PHYSICAL_COUNT_USERS"},
    {"authority": "VIEW_POST_ANAESTHETIC_SETTING"},
    {"authority": "VIEW_PRESCRIPTIONS"},
    {"authority": "VIEW_PRE_OPERATIONAL_CONDITIONS"},
    {"authority": "VIEW_PROCEDURES"},
    {"authority": "VIEW_PROCEDURE_POST_ANAESTHETIC"},
    {"authority": "VIEW_PROVISSIONAL_DIAGNOSIS"},
  ];
  List<Map<String, dynamic>> _permissionList = [
    {
      "groupName": "BILL",
      "permissions": [
        {
          "uid": "0deedab23d8711ed8a53e1d190592312",
          "name": "CREATE_BILL",
          "active": false,
          "displayName": "Can create bill",
          "__typename": "Permission"
        },
        {
          "uid": "0df199d43d8711ed8a53ab05773cdf25",
          "name": "VIEW_BILLS",
          "active": false,
          "displayName": "Can view bills",
          "__typename": "Permission"
        },
        {
          "uid": "0df236163d8711ed8a5393209fb8db2a",
          "name": "VIEW_FACILITY_BILLS",
          "active": false,
          "displayName": "Can view facility bills",
          "__typename": "Permission"
        },
        {
          "uid": "0df2ab483d8711ed8a53816c878fcaaf",
          "name": "CANCEL_BILL",
          "active": false,
          "displayName": "Can cancel bill",
          "__typename": "Permission"
        },
        {
          "uid": "0df3478a3d8711ed8a5327f7d512aa44",
          "name": "VERIFY_BILL",
          "active": false,
          "displayName": "Can verify bill",
          "__typename": "Permission"
        },
        {
          "uid": "0df3bcbc3d8711ed8a53d30bc645499e",
          "name": "CREATE__DEPOSIT_BILL",
          "active": false,
          "displayName": "Can create  deposit bill",
          "__typename": "Permission"
        },
        {
          "uid": "0df431ee3d8711ed8a53d3b2e9ad58be",
          "name": "VIEW__DEPOSIT_BILL",
          "active": false,
          "displayName": "Can view  deposit bill",
          "__typename": "Permission"
        },
        {
          "uid": "0df4a7203d8711ed8a5381b41c10386e",
          "name": "CREATE_COST_SHARING_GROUP",
          "active": false,
          "displayName": "Can create cost sharing group",
          "__typename": "Permission"
        },
        {
          "uid": "0df543623d8711ed8a533b141357401b",
          "name": "DELETE_COST_SHARING_GROUP",
          "active": false,
          "displayName": "Can delete cost sharing group",
          "__typename": "Permission"
        },
        {
          "uid": "0df5b8943d8711ed8a53e7ad224cfd3c",
          "name": "VIEW_COST_SHARING_GROUPS",
          "active": false,
          "displayName": "Can view cost sharing groups",
          "__typename": "Permission"
        },
        {
          "uid": "0df62dc63d8711ed8a5387cebe00eb8f",
          "name": "VIEW_FACILITY_BILL_COST_SHARING_GROUPS",
          "active": false,
          "displayName": "Can view facility bill cost sharing groups",
          "__typename": "Permission"
        },
        {
          "uid": "0df6a2f83d8711ed8a53e1cc9ed2aa82",
          "name": "ROLE_NPG",
          "active": false,
          "displayName": "Can role npg",
          "__typename": "Permission"
        },
        {
          "uid": "bab161d93e3111ed841dbb3413eaa841",
          "name": "CREATE_DEPOSIT_BILL",
          "active": false,
          "displayName": "Can create deposit bill",
          "__typename": "Permission"
        },
        {
          "uid": "bab9c64b3e3111ed841d89abb5302285",
          "name": "VIEW_DEPOSIT_BILL",
          "active": false,
          "displayName": "Can view deposit bill",
          "__typename": "Permission"
        },
        {
          "uid": "77ae186a725811ed939a018ef44c438f",
          "name": "CREATE_COST_SHARING_GROUP_DEPENDENCY",
          "active": false,
          "displayName": "Can create cost sharing group dependency",
          "__typename": "Permission"
        },
        {
          "uid": "77aeb4ac725811ed939a7d5ba497b3e0",
          "name": "DELETE_COST_SHARING_GROUP_DEPENDENCY",
          "active": false,
          "displayName": "Can delete cost sharing group dependency",
          "__typename": "Permission"
        },
        {
          "uid": "77af50ee725811ed939ab99d5ab75ddc",
          "name": "VIEW_COST_SHARING_GROUP_DEPENDENCIE",
          "active": false,
          "displayName": "Can view cost sharing group dependencie",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "CONSULTATION",
      "permissions": [
        {
          "uid": "0df7182a3d8711ed8a53c7ea2eb288df",
          "name": "CREATE_ADMISSION_ORDER",
          "active": false,
          "displayName": "Can create admission order",
          "__typename": "Permission"
        },
        {
          "uid": "0df78d5c3d8711ed8a53731ca3e088a4",
          "name": "VIEW_ADMISSION_ORDERS",
          "active": false,
          "displayName": "Can view admission orders",
          "__typename": "Permission"
        },
        {
          "uid": "0df8028e3d8711ed8a53ef770e1d627e",
          "name": "CREATE_CLERK_SHEET",
          "active": false,
          "displayName": "Can create clerk sheet",
          "__typename": "Permission"
        },
        {
          "uid": "0df877c03d8711ed8a5367ee0d004d32",
          "name": "DELETE_CLERK_SHEET",
          "active": false,
          "displayName": "Can delete clerk sheet",
          "__typename": "Permission"
        },
        {
          "uid": "0df914023d8711ed8a5303637c001967",
          "name": "VIEW_CLERK_SHEET",
          "active": false,
          "displayName": "Can view clerk sheet",
          "__typename": "Permission"
        },
        {
          "uid": "0df962243d8711ed8a539f8a20773316",
          "name": "CREATE_CLERK_SHEET_TYPE_CHILD",
          "active": false,
          "displayName": "Can create clerk sheet type child",
          "__typename": "Permission"
        },
        {
          "uid": "0df9d7563d8711ed8a53bfd4bd7bcb1d",
          "name": "DELETE_CLERK_SHEET_TYPE_CHILD",
          "active": false,
          "displayName": "Can delete clerk sheet type child",
          "__typename": "Permission"
        },
        {
          "uid": "0dfa73983d8711ed8a537371d0a65eb7",
          "name": "VIEW_CLERK_SHEET_TYPE_CHILDREN",
          "active": false,
          "displayName": "Can view clerk sheet type children",
          "__typename": "Permission"
        },
        {
          "uid": "0dfae8ca3d8711ed8a53a51386158f20",
          "name": "CREATE_CLERK_SHEET_TYPE",
          "active": false,
          "displayName": "Can create clerk sheet type",
          "__typename": "Permission"
        },
        {
          "uid": "0dfb5dfc3d8711ed8a53010abf3f5f4c",
          "name": "DELETE_CLERK_SHEET_TYPE",
          "active": false,
          "displayName": "Can delete clerk sheet type",
          "__typename": "Permission"
        },
        {
          "uid": "0dfbd32e3d8711ed8a53bffa5caee5a8",
          "name": "VIEW_CLERK_SHEET_TYPES",
          "active": false,
          "displayName": "Can view clerk sheet types",
          "__typename": "Permission"
        },
        {
          "uid": "0dfc6f703d8711ed8a53795a7f20062c",
          "name": "CREATE_CLIENT_ADMISSION",
          "active": false,
          "displayName": "Can create client admission",
          "__typename": "Permission"
        },
        {
          "uid": "0dfce4a23d8711ed8a53e73c525b243e",
          "name": "VIEW_CLIENT_ADMISSIONS",
          "active": false,
          "displayName": "Can view client admissions",
          "__typename": "Permission"
        },
        {
          "uid": "0dfd59d43d8711ed8a53bbdf0198c9d5",
          "name": "TRANSFER_CLIENT_TO_ANOTHER_BED",
          "active": false,
          "displayName": "Can transfer client to another bed",
          "__typename": "Permission"
        },
        {
          "uid": "0dfda7f63d8711ed8a53396da4fdfdd7",
          "name": "CREATE_CONFIRMED_DIAGNOSIS",
          "active": false,
          "displayName": "Can create confirmed diagnosis",
          "__typename": "Permission"
        },
        {
          "uid": "0dfe1d283d8711ed8a538b5f8be2dfdc",
          "name": "CREATE_CONSULTATION_ROOM",
          "active": false,
          "displayName": "Can create consultation room",
          "__typename": "Permission"
        },
        {
          "uid": "0dfe925a3d8711ed8a535152e8cf10e9",
          "name": "DELETE_CONSULTATION_ROOM",
          "active": false,
          "displayName": "Can delete consultation room",
          "__typename": "Permission"
        },
        {
          "uid": "0dff078c3d8711ed8a5335559ae6a9f2",
          "name": "VIEW_CONSULTATION_ROOMS",
          "active": false,
          "displayName": "Can view consultation rooms",
          "__typename": "Permission"
        },
        {
          "uid": "0dff7cbe3d8711ed8a537129354f9dfe",
          "name": "VIEW_DIAGNOSIS_CATEGORIES",
          "active": false,
          "displayName": "Can view diagnosis categories",
          "__typename": "Permission"
        },
        {
          "uid": "0dfff1f03d8711ed8a53534a7833a647",
          "name": "VIEW_DIAGNOSIS",
          "active": false,
          "displayName": "Can view diagnosis",
          "__typename": "Permission"
        },
        {
          "uid": "0e0067223d8711ed8a537d87cc10e273",
          "name": "CREATE_DISCHARGE_ORDER",
          "active": false,
          "displayName": "Can create discharge order",
          "__typename": "Permission"
        },
        {
          "uid": "0e00dc543d8711ed8a53c74e7ce9dbfc",
          "name": "DELETE_DISCHARGE_ORDER",
          "active": false,
          "displayName": "Can delete discharge order",
          "__typename": "Permission"
        },
        {
          "uid": "0e0151863d8711ed8a538dd1843774c7",
          "name": "VIEW_DISCHARGE_ORDERS",
          "active": false,
          "displayName": "Can view discharge orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e019fa83d8711ed8a53977509f1781f",
          "name": "APPROVE_DISCHARGE_ORDER",
          "active": false,
          "displayName": "Can approve discharge order",
          "__typename": "Permission"
        },
        {
          "uid": "0e0214da3d8711ed8a53d1affef81693",
          "name": "CREATE_INPUT_FORM",
          "active": false,
          "displayName": "Can create input form",
          "__typename": "Permission"
        },
        {
          "uid": "0e028a0c3d8711ed8a534f6c6acbb7f6",
          "name": "DELETE_INPUT_FORM",
          "active": false,
          "displayName": "Can delete input form",
          "__typename": "Permission"
        },
        {
          "uid": "0e02ff3e3d8711ed8a537ffe610165ff",
          "name": "VIEW_INPUT_FORMS",
          "active": false,
          "displayName": "Can view input forms",
          "__typename": "Permission"
        },
        {
          "uid": "0e0374703d8711ed8a530dfbc381645a",
          "name": "CREATE_NURSING_PLAN",
          "active": false,
          "displayName": "Can create nursing plan",
          "__typename": "Permission"
        },
        {
          "uid": "0e03e9a23d8711ed8a533def11be32bd",
          "name": "DELETE_NURSING_PLAN",
          "active": false,
          "displayName": "Can delete nursing plan",
          "__typename": "Permission"
        },
        {
          "uid": "0e045ed43d8711ed8a531fbd8c6e6057",
          "name": "VIEW_NURSING_PLANS",
          "active": false,
          "displayName": "Can view nursing plans",
          "__typename": "Permission"
        },
        {
          "uid": "0e04d4063d8711ed8a530bdbf05c3205",
          "name": "CREATE_OUTPUT_FORM",
          "active": false,
          "displayName": "Can create output form",
          "__typename": "Permission"
        },
        {
          "uid": "0e0549383d8711ed8a538d4bb6525416",
          "name": "DELETE_OUTPUT_FORM",
          "active": false,
          "displayName": "Can delete output form",
          "__typename": "Permission"
        },
        {
          "uid": "0e05be6a3d8711ed8a539126c3c1af64",
          "name": "VIEW_OUTPUT_FORM",
          "active": false,
          "displayName": "Can view output form",
          "__typename": "Permission"
        },
        {
          "uid": "0e06339c3d8711ed8a53893394285b7a",
          "name": "CREATE_PROVISSIONAL_DIAGNOSIS",
          "active": false,
          "displayName": "Can create provissional diagnosis",
          "__typename": "Permission"
        },
        {
          "uid": "0e0681be3d8711ed8a5391fe3aed9cb6",
          "name": "VIEW_PROVISSIONAL_DIAGNOSIS",
          "active": false,
          "displayName": "Can view provissional diagnosis",
          "__typename": "Permission"
        },
        {
          "uid": "0e0793313d8711ed8a535d62fea6216c",
          "name": "VIEW_SERVICE_ORDERS",
          "active": false,
          "displayName": "Can view service orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e0808633d8711ed8a53fdd40ff1f1ef",
          "name": "CREATE_SERVICE_ORDERS",
          "active": false,
          "displayName": "Can create service orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e087d953d8711ed8a53c78599f84265",
          "name": "CANCEL_PENDING_SERVICE_ORDER",
          "active": false,
          "displayName": "Can cancel pending service order",
          "__typename": "Permission"
        },
        {
          "uid": "0e08cbb73d8711ed8a53f9dc12162344",
          "name": "CREATE_TURNING_CHART",
          "active": false,
          "displayName": "Can create turning chart",
          "__typename": "Permission"
        },
        {
          "uid": "0e0940e93d8711ed8a53039b561ae1bd",
          "name": "DELETE_TURNING_CHART",
          "active": false,
          "displayName": "Can delete turning chart",
          "__typename": "Permission"
        },
        {
          "uid": "0e09b61b3d8711ed8a53dd415e1c2490",
          "name": "VIEW_TURNING_CHARTS",
          "active": false,
          "displayName": "Can view turning charts",
          "__typename": "Permission"
        },
        {
          "uid": "0e0a2b4d3d8711ed8a537f23f37ada9a",
          "name": "CREATE_INSURANCE_API_CREDENTIALS",
          "active": false,
          "displayName": "Can create insurance api credentials",
          "__typename": "Permission"
        },
        {
          "uid": "0e0aa07f3d8711ed8a53b95cbf1e8874",
          "name": "VIEW_INSURANCE_CARD_DETAILS",
          "active": false,
          "displayName": "Can view insurance card details",
          "__typename": "Permission"
        },
        {
          "uid": "0e0b15b13d8711ed8a5343e958f7a67d",
          "name": "VIEW_FACILITY_INSURANCE_CONFIGURATIONS",
          "active": false,
          "displayName": "Can view facility insurance configurations",
          "__typename": "Permission"
        },
        {
          "uid": "0e0b8ae33d8711ed8a533920c0f1d407",
          "name": "VIEW_FACILITY_ITEMS",
          "active": false,
          "displayName": "Can view facility items",
          "__typename": "Permission"
        },
        {
          "uid": "0e0bd9053d8711ed8a538145bd7ade93",
          "name": "CREATE_FACILITY_ITEM",
          "active": false,
          "displayName": "Can create facility item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0c4e373d8711ed8a53432f6c9a7fb1",
          "name": "DELETE_FACILITY_ITEM",
          "active": false,
          "displayName": "Can delete facility item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0cc3693d8711ed8a53aba3ad279f7b",
          "name": "CREATE_FACILITY_ENTRY_ITEM",
          "active": false,
          "displayName": "Can create facility entry item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0d118b3d8711ed8a5325f496f738b0",
          "name": "DELETE_FACILITY_ENTRY_ITEM",
          "active": false,
          "displayName": "Can delete facility entry item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0dadce3d8711ed8a53dbd0b486f4fb",
          "name": "CREATE_ITEM",
          "active": false,
          "displayName": "Can create item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0e23003d8711ed8a53e30429685b7b",
          "name": "DELETE_ITEM",
          "active": false,
          "displayName": "Can delete item",
          "__typename": "Permission"
        },
        {
          "uid": "0e0e98323d8711ed8a536f4d84e7d718",
          "name": "VIEW_ITEMS",
          "active": false,
          "displayName": "Can view items",
          "__typename": "Permission"
        },
        {
          "uid": "0e0ee6543d8711ed8a5305ee023b663b",
          "name": "CREATE_ITEM_PRICE",
          "active": false,
          "displayName": "Can create item price",
          "__typename": "Permission"
        },
        {
          "uid": "0e0f82963d8711ed8a53ad642984a249",
          "name": "DELETE_ITEM_PRICE",
          "active": false,
          "displayName": "Can delete item price",
          "__typename": "Permission"
        },
        {
          "uid": "0e0ff7c83d8711ed8a5371f87e3594b2",
          "name": "VIEW_ITEM_PRICES",
          "active": false,
          "displayName": "Can view item prices",
          "__typename": "Permission"
        },
        {
          "uid": "0e1045ea3d8711ed8a5321ff3f813b38",
          "name": "DOWNLOAD_ITEM_LIST",
          "active": false,
          "displayName": "Can download item list",
          "__typename": "Permission"
        },
        {
          "uid": "0e10bb1c3d8711ed8a530344b816a224",
          "name": "UPLOAD_ITEMS",
          "active": false,
          "displayName": "Can upload items",
          "__typename": "Permission"
        },
        {
          "uid": "0e11304e3d8711ed8a538d86dd1bd96c",
          "name": "DOWNLOAD_ITEM_PRICE",
          "active": false,
          "displayName": "Can download item price",
          "__typename": "Permission"
        },
        {
          "uid": "0e117e703d8711ed8a537b7a80cde29e",
          "name": "UPLOAD_ITEM_PRICES",
          "active": false,
          "displayName": "Can upload item prices",
          "__typename": "Permission"
        },
        {
          "uid": "0e11f3a23d8711ed8a53a1897aa535b0",
          "name": "UPLOAD_FACILITY_ITEM",
          "active": false,
          "displayName": "Can upload facility item",
          "__typename": "Permission"
        },
        {
          "uid": "0e1268d43d8711ed8a53cf267939303a",
          "name": "DOWNLOAD_FACILITY_ITEM",
          "active": false,
          "displayName": "Can download facility item",
          "__typename": "Permission"
        },
        {
          "uid": "77b59298725811ed939a393781321c5c",
          "name": "CANCEL_SERVICE_ORDER",
          "active": false,
          "displayName": "Can cancel service order",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "LABORATORY",
      "permissions": [
        {
          "uid": "0e1305193d8711ed8a53b9ad0546c417",
          "name": "CREATE_EQUIPMENT",
          "active": false,
          "displayName": "Can create equipment",
          "__typename": "Permission"
        },
        {
          "uid": "0e137a4b3d8711ed8a53534ef1e7c92d",
          "name": "DELETE_EQUIPMENT",
          "active": false,
          "displayName": "Can delete equipment",
          "__typename": "Permission"
        },
        {
          "uid": "0e143d9f3d8711ed8a532b41bb804ebf",
          "name": "CREATE_EQUIPMENT_TEST",
          "active": false,
          "displayName": "Can create equipment test",
          "__typename": "Permission"
        },
        {
          "uid": "0e14b2d13d8711ed8a53993f5ad75c1c",
          "name": "DELETE_EQUIPMENT_TEST",
          "active": false,
          "displayName": "Can delete equipment test",
          "__typename": "Permission"
        },
        {
          "uid": "0e1528033d8711ed8a536ddfea872f62",
          "name": "VIEW_EQUIPMENT_TESTS",
          "active": false,
          "displayName": "Can view equipment tests",
          "__typename": "Permission"
        },
        {
          "uid": "0e159d353d8711ed8a53d746dfacbf36",
          "name": "CREATE_EQUIPMENT_TYPE",
          "active": false,
          "displayName": "Can create equipment type",
          "__typename": "Permission"
        },
        {
          "uid": "0e1612673d8711ed8a5389a4e2d0d6cf",
          "name": "DELETE_EQUIPMENT_TYPE",
          "active": false,
          "displayName": "Can delete equipment type",
          "__typename": "Permission"
        },
        {
          "uid": "0e1687993d8711ed8a5385a039c0a0f1",
          "name": "VIEW_EQUIPMENT_TYPES",
          "active": false,
          "displayName": "Can view equipment types",
          "__typename": "Permission"
        },
        {
          "uid": "0e16d5bb3d8711ed8a53c566cf590f36",
          "name": "CREATE_FACILITY_EQUIPMENT",
          "active": false,
          "displayName": "Can create facility equipment",
          "__typename": "Permission"
        },
        {
          "uid": "0e174aed3d8711ed8a536975afb8cd0d",
          "name": "DELETE_FACILITY_EQUIPMENT",
          "active": false,
          "displayName": "Can delete facility equipment",
          "__typename": "Permission"
        },
        {
          "uid": "0e17c01f3d8711ed8a53d3ba0eb86ec5",
          "name": "VIEW_FACILITY_EQUIPMENTS",
          "active": false,
          "displayName": "Can view facility equipments",
          "__typename": "Permission"
        },
        {
          "uid": "0e1835513d8711ed8a530f5677bdc9c1",
          "name": "VIEW_CLIENT_WITHOUT_SAMPLES",
          "active": false,
          "displayName": "Can view client without samples",
          "__typename": "Permission"
        },
        {
          "uid": "0e1883733d8711ed8a53cb478feb007c",
          "name": "VIEW_UNTESTED_SAMPLES",
          "active": false,
          "displayName": "Can view untested samples",
          "__typename": "Permission"
        },
        {
          "uid": "0e18f8a53d8711ed8a53db679e1fbcdf",
          "name": "VIEW_UNPROVED_LAB_TEST_RESULTS",
          "active": false,
          "displayName": "Can view unproved lab test results",
          "__typename": "Permission"
        },
        {
          "uid": "0e196dd73d8711ed8a534f973689ab71",
          "name": "VIEW_LAB_TEST_RESULTS",
          "active": false,
          "displayName": "Can view lab test results",
          "__typename": "Permission"
        },
        {
          "uid": "0e19e3093d8711ed8a53c5bfd37f3296",
          "name": "CREATE_LAB_ORDER",
          "active": false,
          "displayName": "Can create lab order",
          "__typename": "Permission"
        },
        {
          "uid": "0e1a312b3d8711ed8a53a9d402e087db",
          "name": "DELETE_LAB_ORDER",
          "active": false,
          "displayName": "Can delete lab order",
          "__typename": "Permission"
        },
        {
          "uid": "0e1aa65d3d8711ed8a537775dca58be4",
          "name": "VIEW_LAB_ORDERS",
          "active": false,
          "displayName": "Can view lab orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e1b1b8f3d8711ed8a53b55b2033947f",
          "name": "CREATE_LAB_ORDER_TEST_RESULT",
          "active": false,
          "displayName": "Can create lab order test result",
          "__typename": "Permission"
        },
        {
          "uid": "0e1b68b13d8711ed8a5361aa2b7d0c69",
          "name": "APPROVE_LAB_ORDER_TEST_RESULT",
          "active": false,
          "displayName": "Can approve lab order test result",
          "__typename": "Permission"
        },
        {
          "uid": "0e1bdde33d8711ed8a53ff24c652e2e2",
          "name": "READ_ATTACHMENT",
          "active": false,
          "displayName": "Can read attachment",
          "__typename": "Permission"
        },
        {
          "uid": "0e1c2c053d8711ed8a537b6f5204b227",
          "name": "CREATE_LAB_TEST",
          "active": false,
          "displayName": "Can create lab test",
          "__typename": "Permission"
        },
        {
          "uid": "0e1ca1373d8711ed8a53032dd01c1e5e",
          "name": "DELETE_LAB_TEST",
          "active": false,
          "displayName": "Can delete lab test",
          "__typename": "Permission"
        },
        {
          "uid": "0e1d8b9b3d8711ed8a530d0fb2e9cde6",
          "name": "CREATE_OCCURANCE",
          "active": false,
          "displayName": "Can create occurance",
          "__typename": "Permission"
        },
        {
          "uid": "0e1dd9bd3d8711ed8a53bf8af38740ce",
          "name": "DELETE_OCCURANCE",
          "active": false,
          "displayName": "Can delete occurance",
          "__typename": "Permission"
        },
        {
          "uid": "0e1e4eef3d8711ed8a5367572fc2fde9",
          "name": "VIEW_OCCURANCES",
          "active": false,
          "displayName": "Can view occurances",
          "__typename": "Permission"
        },
        {
          "uid": "0e1ec4213d8711ed8a532373cac4c773",
          "name": "CREATE_OCCURANCE_TYPE",
          "active": false,
          "displayName": "Can create occurance type",
          "__typename": "Permission"
        },
        {
          "uid": "0e1f39533d8711ed8a532b19d991aa59",
          "name": "DELETE_OCCURANCE_TYPE",
          "active": false,
          "displayName": "Can delete occurance type",
          "__typename": "Permission"
        },
        {
          "uid": "0e1f87753d8711ed8a53e5a788d22039",
          "name": "VIEW_OCCURANCE_TYPES",
          "active": false,
          "displayName": "Can view occurance types",
          "__typename": "Permission"
        },
        {
          "uid": "0e1ffca73d8711ed8a538310c3df4d94",
          "name": "CREATE_SAMPLE",
          "active": false,
          "displayName": "Can create sample",
          "__typename": "Permission"
        },
        {
          "uid": "0e2071d93d8711ed8a53a9d165eb8675",
          "name": "DELETE_SAMPLE",
          "active": false,
          "displayName": "Can delete sample",
          "__typename": "Permission"
        },
        {
          "uid": "0e20e70b3d8711ed8a533fb810cdfb2d",
          "name": "VIEW_SAMPLES",
          "active": false,
          "displayName": "Can view samples",
          "__typename": "Permission"
        },
        {
          "uid": "0e215c3d3d8711ed8a534166350918e2",
          "name": "REJECT_SAMPLE",
          "active": false,
          "displayName": "Can reject sample",
          "__typename": "Permission"
        },
        {
          "uid": "0e21aa5f3d8711ed8a53e17e63cb3801",
          "name": "COLLECT_SAMPLE",
          "active": false,
          "displayName": "Can collect sample",
          "__typename": "Permission"
        },
        {
          "uid": "0e2246a13d8711ed8a53afaea106d5fe",
          "name": "VIEW_UNCOLLECTED_SAMPLES",
          "active": false,
          "displayName": "Can view uncollected samples",
          "__typename": "Permission"
        },
        {
          "uid": "0e2294c33d8711ed8a53b99a40a7f536",
          "name": "VIEW_REJECTED_SAMPLES",
          "active": false,
          "displayName": "Can view rejected samples",
          "__typename": "Permission"
        },
        {
          "uid": "0e2309f53d8711ed8a536195a8b12fed",
          "name": "RECOLLECT_SAMPLE",
          "active": false,
          "displayName": "Can recollect sample",
          "__typename": "Permission"
        },
        {
          "uid": "0e237f273d8711ed8a535d680f2fe0eb",
          "name": "CREATE_SAMPLE_REJECTION_REASON",
          "active": false,
          "displayName": "Can create sample rejection reason",
          "__typename": "Permission"
        },
        {
          "uid": "0e23cd493d8711ed8a537b255f2aecb0",
          "name": "DELETE_SAMPLE_REJECTION_REASON",
          "active": false,
          "displayName": "Can delete sample rejection reason",
          "__typename": "Permission"
        },
        {
          "uid": "0e24427b3d8711ed8a53db72a5e2f96e",
          "name": "VIEW_SAMPLE_REJECTION_REASONS",
          "active": false,
          "displayName": "Can view sample rejection reasons",
          "__typename": "Permission"
        },
        {
          "uid": "0e24b7ad3d8711ed8a53f308f38f60d8",
          "name": "CREATE_SAMPLE_TYPE",
          "active": false,
          "displayName": "Can create sample type",
          "__typename": "Permission"
        },
        {
          "uid": "0e2505cf3d8711ed8a53d1153327a9e4",
          "name": "DELETE_SAMPLE_TYPE",
          "active": false,
          "displayName": "Can delete sample type",
          "__typename": "Permission"
        },
        {
          "uid": "0e257b013d8711ed8a531b612a3e0bbc",
          "name": "VIEW_SAMPLE_TYPE",
          "active": false,
          "displayName": "Can view sample type",
          "__typename": "Permission"
        },
        {
          "uid": "0e25f0333d8711ed8a53890cf481ea6d",
          "name": "CREATE_SUB_DEPARTMENT",
          "active": false,
          "displayName": "Can create sub department",
          "__typename": "Permission"
        },
        {
          "uid": "0e263e553d8711ed8a53637e508faab8",
          "name": "DELETE_SUB_DEPARTMENT",
          "active": false,
          "displayName": "Can delete sub department",
          "__typename": "Permission"
        },
        {
          "uid": "0e26b3873d8711ed8a53612bdfdf5bfb",
          "name": "VIEW_SUB_DEPARTMENT",
          "active": false,
          "displayName": "Can view sub department",
          "__typename": "Permission"
        },
        {
          "uid": "0e2701a93d8711ed8a533de05ccccfc1",
          "name": "VIEW_USER_SUB_DEPARTMENT_BY_DEPARTMENT",
          "active": false,
          "displayName": "Can view user sub department by department",
          "__typename": "Permission"
        },
        {
          "uid": "0e2776db3d8711ed8a536fde421b8cce",
          "name": "CREATE_SUB_DEPARTMENT_ACCESS",
          "active": false,
          "displayName": "Can create sub department access",
          "__typename": "Permission"
        },
        {
          "uid": "0e28613f3d8711ed8a53ef292228fd82",
          "name": "REMOVE_SUB_DEPARTMENT_ACCESS_USER",
          "active": false,
          "displayName": "Can remove sub department access user",
          "__typename": "Permission"
        },
        {
          "uid": "0e2b206d3d8711ed8a530f92f88e4c42",
          "name": "DELETE_CABINET_DOOR",
          "active": false,
          "displayName": "Can delete cabinet door",
          "__typename": "Permission"
        },
        {
          "uid": "6dc1f2f43ef511edb9d6c5256a72461f",
          "name": "VIEW_SUB_DEPARTMENT_ACCESSES",
          "active": false,
          "displayName": "Can view sub department accesses",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "LABORATRORY",
      "permissions": [
        {
          "uid": "0e13c86d3d8711ed8a53ad3db91f21f6",
          "name": "VIEW_EQUIPMENTS",
          "active": false,
          "displayName": "Can view equipments",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "LABORATPORY",
      "permissions": [
        {
          "uid": "0e1d16693d8711ed8a530d6f1d488c7f",
          "name": "VIEW_LAB_TESTS",
          "active": false,
          "displayName": "Can view lab tests",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": null,
      "permissions": [
        {
          "uid": "0e27ec0d3d8711ed8a533b99e5a33026",
          "name": "VIEW_SUB_DEPARTMENT_ACCESSES.LABORATORY",
          "active": false,
          "displayName": "Can view sub department accesses.laboratory",
          "__typename": "Permission"
        },
        {
          "uid": "0a4f4aa2ab8211edb8aa1bce8f011fb4",
          "name": "<<<<<<< HEAD",
          "active": false,
          "displayName": "Can <<<<<<< head",
          "__typename": "Permission"
        },
        {
          "uid": "0a5abc7eab8211edb8aa21364447aced",
          "name": "=======",
          "active": false,
          "displayName": "Can =======",
          "__typename": "Permission"
        },
        {
          "uid": "0a5b58c0ab8211edb8aa33f2b30c3c74",
          "name": ">>>>>>> 4431b56bc243f9fb9e1f9109c4f0c50d5472991d",
          "active": false,
          "displayName": "Can >>>>>>> 4431b56bc243f9fb9e1f9109c4f0c50d5472991d",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "MORTUARY",
      "permissions": [
        {
          "uid": "0e28af613d8711ed8a53dff785b23c08",
          "name": "VIEW_CABINETS",
          "active": false,
          "displayName": "Can view cabinets",
          "__typename": "Permission"
        },
        {
          "uid": "0e2924933d8711ed8a534f4c12338740",
          "name": "CREATE_CABINET",
          "active": false,
          "displayName": "Can create cabinet",
          "__typename": "Permission"
        },
        {
          "uid": "0e2999c53d8711ed8a53354cd82a4e25",
          "name": "DELETE_CABINET",
          "active": false,
          "displayName": "Can delete cabinet",
          "__typename": "Permission"
        },
        {
          "uid": "0e2a0ef73d8711ed8a532758f7b2441f",
          "name": "VIEW_CABINET_WITH_FREE_CABDOORS",
          "active": false,
          "displayName": "Can view cabinet with free cabdoors",
          "__typename": "Permission"
        },
        {
          "uid": "0e2a5d193d8711ed8a53059095b63a55",
          "name": "VIEW_CABINET_DDORS",
          "active": false,
          "displayName": "Can view cabinet ddors",
          "__typename": "Permission"
        },
        {
          "uid": "0e2ad24b3d8711ed8a531d4726de8c78",
          "name": "CREATE_CABINET_DOOR",
          "active": false,
          "displayName": "Can create cabinet door",
          "__typename": "Permission"
        },
        {
          "uid": "0e2b959f3d8711ed8a53795977fef2f4",
          "name": "CREATE_CORPES_ADMISSION",
          "active": false,
          "displayName": "Can create corpes admission",
          "__typename": "Permission"
        },
        {
          "uid": "0e2be3c13d8711ed8a53c14e4b680b1d",
          "name": "VIEW_CORPES_ADMISSIONS",
          "active": false,
          "displayName": "Can view corpes admissions",
          "__typename": "Permission"
        },
        {
          "uid": "0e2c58f33d8711ed8a5387e5ac825d36",
          "name": "DISCHARGE_CORPES_ADMISSION",
          "active": false,
          "displayName": "Can discharge corpes admission",
          "__typename": "Permission"
        },
        {
          "uid": "0e2ca7153d8711ed8a532f50976cbd8a",
          "name": "CREATE_CORPSE",
          "active": false,
          "displayName": "Can create corpse",
          "__typename": "Permission"
        },
        {
          "uid": "0e2d1c473d8711ed8a53e383557bf75d",
          "name": "DELETE_CORPSE",
          "active": false,
          "displayName": "Can delete corpse",
          "__typename": "Permission"
        },
        {
          "uid": "0e2d6a693d8711ed8a53c7550e52910f",
          "name": "VIEW_CORPSES",
          "active": false,
          "displayName": "Can view corpses",
          "__typename": "Permission"
        },
        {
          "uid": "0e2ddf9b3d8711ed8a53176c3ea38a18",
          "name": "CREATE_CORPSE_VERIFICATION",
          "active": false,
          "displayName": "Can create corpse verification",
          "__typename": "Permission"
        },
        {
          "uid": "0e2e2dbd3d8711ed8a53f91e462161b2",
          "name": "CREATE_DECEASED_CLNT_VERIFICATION",
          "active": false,
          "displayName": "Can create deceased clnt verification",
          "__typename": "Permission"
        },
        {
          "uid": "0e2ea2ef3d8711ed8a53f9e9d6143d9a",
          "name": "CREATE_DECEASED_ADMTD_CLNT",
          "active": false,
          "displayName": "Can create deceased admtd clnt",
          "__typename": "Permission"
        },
        {
          "uid": "0e2f18223d8711ed8a5357192506cc0a",
          "name": "CREATE_CORPSE_SERVICE",
          "active": false,
          "displayName": "Can create corpse service",
          "__typename": "Permission"
        },
        {
          "uid": "0e2f8d543d8711ed8a53a94e3df81b78",
          "name": "DELETE_CORPSE_SERVICE",
          "active": false,
          "displayName": "Can delete corpse service",
          "__typename": "Permission"
        },
        {
          "uid": "0e2fdb763d8711ed8a53a5f35da5196b",
          "name": "VIEW_CORPSE_SERVICES",
          "active": false,
          "displayName": "Can view corpse services",
          "__typename": "Permission"
        },
        {
          "uid": "0e3050a83d8711ed8a531d0bf1ea1181",
          "name": "CREATE_MORTUARY_ORDER",
          "active": false,
          "displayName": "Can create mortuary order",
          "__typename": "Permission"
        },
        {
          "uid": "0e309eca3d8711ed8a53df822c29ac77",
          "name": "DELETE_MORTUARY_ORDER",
          "active": false,
          "displayName": "Can delete mortuary order",
          "__typename": "Permission"
        },
        {
          "uid": "0e3113fc3d8711ed8a53f7657ce37413",
          "name": "VIEW_MORTUARY_ORDERS",
          "active": false,
          "displayName": "Can view mortuary orders",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "NURSING",
      "permissions": [
        {
          "uid": "0e31621e3d8711ed8a53390029e3eb4b",
          "name": "CREATE_BED",
          "active": false,
          "displayName": "Can create bed",
          "__typename": "Permission"
        },
        {
          "uid": "0e31d7503d8711ed8a53fbb3ba966603",
          "name": "DELETE_BED",
          "active": false,
          "displayName": "Can delete bed",
          "__typename": "Permission"
        },
        {
          "uid": "0e324c823d8711ed8a53b94a544aa7af",
          "name": "VIEW_BEDS",
          "active": false,
          "displayName": "Can view beds",
          "__typename": "Permission"
        },
        {
          "uid": "0e32c1b43d8711ed8a537b5add0c1438",
          "name": "CREATE_BED_TYPE",
          "active": false,
          "displayName": "Can create bed type",
          "__typename": "Permission"
        },
        {
          "uid": "0e330fd63d8711ed8a53837cd0537b2f",
          "name": "DELETE_BED_TYPE",
          "active": false,
          "displayName": "Can delete bed type",
          "__typename": "Permission"
        },
        {
          "uid": "0e3385083d8711ed8a53bbfe4a874f94",
          "name": "VIEW_BED_TYPES",
          "active": false,
          "displayName": "Can view bed types",
          "__typename": "Permission"
        },
        {
          "uid": "0e33fa3a3d8711ed8a535d43f089cb99",
          "name": "CREATE_WARD",
          "active": false,
          "displayName": "Can create ward",
          "__typename": "Permission"
        },
        {
          "uid": "0e34485c3d8711ed8a53ddc143bfe321",
          "name": "DELETE_WARD",
          "active": false,
          "displayName": "Can delete ward",
          "__typename": "Permission"
        },
        {
          "uid": "0e34bd8e3d8711ed8a537915767b3581",
          "name": "VIEW_WARDS",
          "active": false,
          "displayName": "Can view wards",
          "__typename": "Permission"
        },
        {
          "uid": "0e350bb03d8711ed8a535bd6b38d26c0",
          "name": "ASSIGN_NURSE_TO_WARD",
          "active": false,
          "displayName": "Can assign nurse to ward",
          "__typename": "Permission"
        },
        {
          "uid": "0e3580e23d8711ed8a53b983fa533e37",
          "name": "VIEW_WARD_BY_NURSE",
          "active": false,
          "displayName": "Can view ward by nurse",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "PHARMACY",
      "permissions": [
        {
          "uid": "0e35cf043d8711ed8a532f9f8e14e85c",
          "name": "CREATE_ISSUING",
          "active": false,
          "displayName": "Can create issuing",
          "__typename": "Permission"
        },
        {
          "uid": "0e3644363d8711ed8a530b050c299246",
          "name": "VIEW_ISSUING",
          "active": false,
          "displayName": "Can view issuing",
          "__typename": "Permission"
        },
        {
          "uid": "0e3692583d8711ed8a533508cb1be4bc",
          "name": "VIEW_ISSUING_ITEMS",
          "active": false,
          "displayName": "Can view issuing items",
          "__typename": "Permission"
        },
        {
          "uid": "0e37078a3d8711ed8a53a572768caeea",
          "name": "CONFIRM_RECEIVING_ISSUED_ITEMS",
          "active": false,
          "displayName": "Can confirm receiving issued items",
          "__typename": "Permission"
        },
        {
          "uid": "0e377cbc3d8711ed8a53a10877918fae",
          "name": "VIEW_PHYSICAL_COUNTS",
          "active": false,
          "displayName": "Can view physical counts",
          "__typename": "Permission"
        },
        {
          "uid": "0e37cade3d8711ed8a537d0931cf172a",
          "name": "CREATE_PHYSICAL_COUNTS",
          "active": false,
          "displayName": "Can create physical counts",
          "__typename": "Permission"
        },
        {
          "uid": "0e3840103d8711ed8a53d195d914ea83",
          "name": "CREATE_REORDER_LEVEL",
          "active": false,
          "displayName": "Can create reorder level",
          "__typename": "Permission"
        },
        {
          "uid": "0e388e323d8711ed8a53ed6c03e92c0b",
          "name": "DELETE_REORDER_LEVEL",
          "active": false,
          "displayName": "Can delete reorder level",
          "__typename": "Permission"
        },
        {
          "uid": "0e38dc543d8711ed8a539f6ddad8c349",
          "name": "VIEW_REORDER_LEVELS",
          "active": false,
          "displayName": "Can view reorder levels",
          "__typename": "Permission"
        },
        {
          "uid": "0e3951863d8711ed8a536b2140e126eb",
          "name": "CREATE_REQUISITION",
          "active": false,
          "displayName": "Can create requisition",
          "__typename": "Permission"
        },
        {
          "uid": "0e39c6b83d8711ed8a5365bb4773a281",
          "name": "VIEW_REQUISITIONS",
          "active": false,
          "displayName": "Can view requisitions",
          "__typename": "Permission"
        },
        {
          "uid": "0e3a14da3d8711ed8a53758860d41246",
          "name": "SUBMIT_REQUISITION_REQUEST",
          "active": false,
          "displayName": "Can submit requisition request",
          "__typename": "Permission"
        },
        {
          "uid": "0e3a8a0c3d8711ed8a536d8a19ce4495",
          "name": "VIEW_REQUISITION_REQUEST",
          "active": false,
          "displayName": "Can view requisition request",
          "__typename": "Permission"
        },
        {
          "uid": "0e3aff3e3d8711ed8a5307a12af3563f",
          "name": "DELETE_REQUISITION",
          "active": false,
          "displayName": "Can delete requisition",
          "__typename": "Permission"
        },
        {
          "uid": "0e3b4d603d8711ed8a530b664de7a33a",
          "name": "CREATE_ITEM_REQUISITION",
          "active": false,
          "displayName": "Can create item requisition",
          "__typename": "Permission"
        },
        {
          "uid": "0e3bc2923d8711ed8a532b38e95e474d",
          "name": "DELETE_ITEM_REQUISITION",
          "active": false,
          "displayName": "Can delete item requisition",
          "__typename": "Permission"
        },
        {
          "uid": "0e3c10b43d8711ed8a53bf5061e86ab9",
          "name": "VIEW_STOCKS",
          "active": false,
          "displayName": "Can view stocks",
          "__typename": "Permission"
        },
        {
          "uid": "0e3c85e73d8711ed8a53af9a440cd638",
          "name": "CREATE_STOCK_RECEIVING",
          "active": false,
          "displayName": "Can create stock receiving",
          "__typename": "Permission"
        },
        {
          "uid": "0e3cfb193d8711ed8a538f0f1c10bcf3",
          "name": "CONFIRM_STOCK_RECEIVING",
          "active": false,
          "displayName": "Can confirm stock receiving",
          "__typename": "Permission"
        },
        {
          "uid": "0e3d493b3d8711ed8a533947e8c99d0a",
          "name": "VIEW_STOCK_RECEIVINGS",
          "active": false,
          "displayName": "Can view stock receivings",
          "__typename": "Permission"
        },
        {
          "uid": "0e3d975d3d8711ed8a5371414f3c6bb1",
          "name": "VIEW_STOCK_RECEIVING_ITEMS",
          "active": false,
          "displayName": "Can view stock receiving items",
          "__typename": "Permission"
        },
        {
          "uid": "0e3e0c8f3d8711ed8a53df7b2fd18559",
          "name": "DELETE_STOCK_RECEIVING",
          "active": false,
          "displayName": "Can delete stock receiving",
          "__typename": "Permission"
        },
        {
          "uid": "0e3e5ab13d8711ed8a5331b9784cf136",
          "name": "CREATE_ITEM_RECEIVING",
          "active": false,
          "displayName": "Can create item receiving",
          "__typename": "Permission"
        },
        {
          "uid": "0e3ecfe33d8711ed8a5367bd1699702e",
          "name": "DELETE_ITEM_RECEIVING",
          "active": false,
          "displayName": "Can delete item receiving",
          "__typename": "Permission"
        },
        {
          "uid": "0e3f1e053d8711ed8a5341f2bf84d4cb",
          "name": "VIEW_STORE_ACCESSES",
          "active": false,
          "displayName": "Can view store accesses",
          "__typename": "Permission"
        },
        {
          "uid": "0e3f93373d8711ed8a538195c06cdd03",
          "name": "CREATE_STORE_ACCESS",
          "active": false,
          "displayName": "Can create store access",
          "__typename": "Permission"
        },
        {
          "uid": "0e3fe1593d8711ed8a536b320ed72277",
          "name": "VIEW_STORES",
          "active": false,
          "displayName": "Can view stores",
          "__typename": "Permission"
        },
        {
          "uid": "0e402f7b3d8711ed8a536355b363ebd8",
          "name": "CREATE_STORE",
          "active": false,
          "displayName": "Can create store",
          "__typename": "Permission"
        },
        {
          "uid": "0e40a4ad3d8711ed8a531f8adad4fc28",
          "name": "DELETE_STORE",
          "active": false,
          "displayName": "Can delete store",
          "__typename": "Permission"
        },
        {
          "uid": "0e40f2cf3d8711ed8a536b6eca726c57",
          "name": "ASSIGN_REMOVE_USER_FROM_STORE",
          "active": false,
          "displayName": "Can assign remove user from store",
          "__typename": "Permission"
        },
        {
          "uid": "0e4168013d8711ed8a5321dbb4ac0bbf",
          "name": "VIEW_STORE_TO_STORE_ACCESS",
          "active": false,
          "displayName": "Can view store to store access",
          "__typename": "Permission"
        },
        {
          "uid": "0e41b6233d8711ed8a532bf940a11942",
          "name": "CREATE_STORE_TO_STORE_ACCESS",
          "active": false,
          "displayName": "Can create store to store access",
          "__typename": "Permission"
        },
        {
          "uid": "0e422b553d8711ed8a5311270c77db89",
          "name": "REMOVE_STORE_TO_STORE_ACCESS",
          "active": false,
          "displayName": "Can remove store to store access",
          "__typename": "Permission"
        },
        {
          "uid": "0e4279773d8711ed8a53d36ae9f95bb6",
          "name": "CREATE_VENDOR",
          "active": false,
          "displayName": "Can create vendor",
          "__typename": "Permission"
        },
        {
          "uid": "0e42eea93d8711ed8a53670a51fcdfc5",
          "name": "DELETE_VENDOR",
          "active": false,
          "displayName": "Can delete vendor",
          "__typename": "Permission"
        },
        {
          "uid": "0e433ccb3d8711ed8a53ef2807d08dcf",
          "name": "VIEW_VENDORS",
          "active": false,
          "displayName": "Can view vendors",
          "__typename": "Permission"
        },
        {
          "uid": "77ad7c28725811ed939ac32fa5d009eb",
          "name": "VIEW_STOCK_REORDER_LEVELS",
          "active": false,
          "displayName": "Can view stock reorder levels",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "RADIOLOGY",
      "permissions": [
        {
          "uid": "0e43b1fd3d8711ed8a530be440c4cf26",
          "name": "CREATE_EQUIPMENT_IMAGING_TEST",
          "active": false,
          "displayName": "Can create equipment imaging test",
          "__typename": "Permission"
        },
        {
          "uid": "0e44001f3d8711ed8a539507c0d7a22d",
          "name": "DELETE_EQUIPMENT_IMAGING_TEST",
          "active": false,
          "displayName": "Can delete equipment imaging test",
          "__typename": "Permission"
        },
        {
          "uid": "0e4475513d8711ed8a53b9f66244af72",
          "name": "VIEW_EQUIPMENT_IMAGING_TESTS",
          "active": false,
          "displayName": "Can view equipment imaging tests",
          "__typename": "Permission"
        },
        {
          "uid": "0e44c3733d8711ed8a53d7a1cd5e3d95",
          "name": "CREATE_IMAGING_TEST",
          "active": false,
          "displayName": "Can create imaging test",
          "__typename": "Permission"
        },
        {
          "uid": "0e4511953d8711ed8a53cf973276efde",
          "name": "DELETE_IMAGING_TEST",
          "active": false,
          "displayName": "Can delete imaging test",
          "__typename": "Permission"
        },
        {
          "uid": "0e4586c73d8711ed8a53fb1d01a3fc7b",
          "name": "VIEW_IMAGING_TESTS",
          "active": false,
          "displayName": "Can view imaging tests",
          "__typename": "Permission"
        },
        {
          "uid": "0e45d4e93d8711ed8a539fb4f6c6da6c",
          "name": "CREATE_RADIOLOGY_ORDER",
          "active": false,
          "displayName": "Can create radiology order",
          "__typename": "Permission"
        },
        {
          "uid": "0e46230b3d8711ed8a5377c32cb61723",
          "name": "DELETE_RADIOLOGY_ORDERS",
          "active": false,
          "displayName": "Can delete radiology orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e46983d3d8711ed8a533d0c76058749",
          "name": "VIEW_RADIOLOGY_ORDERS",
          "active": false,
          "displayName": "Can view radiology orders",
          "__typename": "Permission"
        },
        {
          "uid": "0e46e65f3d8711ed8a53138923642bcf",
          "name": "CREATE_RADIOLOGY_ORDER_RESULT",
          "active": false,
          "displayName": "Can create radiology order result",
          "__typename": "Permission"
        },
        {
          "uid": "0e4734813d8711ed8a53c1d058590885",
          "name": "VIEW_RADIOLOGY_ORDER_RESULTS",
          "active": false,
          "displayName": "Can view radiology order results",
          "__typename": "Permission"
        },
        {
          "uid": "0e47a9b33d8711ed8a5367137ef3b9f1",
          "name": "APPROVE_RADIOLOGY_ORDER_RESULT",
          "active": false,
          "displayName": "Can approve radiology order result",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "REFERAL",
      "permissions": [
        {
          "uid": "0e47f7d53d8711ed8a5357e4166e7961",
          "name": "CREATE_APPOINTMENT",
          "active": false,
          "displayName": "Can create appointment",
          "__typename": "Permission"
        },
        {
          "uid": "0e486d073d8711ed8a53d7eba2a888dd",
          "name": "START_APPOINTMENT_VISIT",
          "active": false,
          "displayName": "Can start appointment visit",
          "__typename": "Permission"
        },
        {
          "uid": "0e48e2393d8711ed8a538d9294677dd3",
          "name": "VIEW_APPOINTMENTS",
          "active": false,
          "displayName": "Can view appointments",
          "__typename": "Permission"
        },
        {
          "uid": "0e49305b3d8711ed8a53ef467df44470",
          "name": "CREATE_INVESTIGATION_REFERAL",
          "active": false,
          "displayName": "Can create investigation referal",
          "__typename": "Permission"
        },
        {
          "uid": "0e497e7d3d8711ed8a53654f4c7cae78",
          "name": "CREATE_INVESTIGATION_REFERAL_RESULT",
          "active": false,
          "displayName": "Can create investigation referal result",
          "__typename": "Permission"
        },
        {
          "uid": "0e49cc9f3d8711ed8a538338e71e8328",
          "name": "VIEW_INVESTIGATION_REFERAL_QUEU",
          "active": false,
          "displayName": "Can view investigation referal queu",
          "__typename": "Permission"
        },
        {
          "uid": "0e4a41d13d8711ed8a5359888db19af7",
          "name": "VIEW_INVESTIGATION_REFERAL",
          "active": false,
          "displayName": "Can view investigation referal",
          "__typename": "Permission"
        },
        {
          "uid": "0e4a8ff33d8711ed8a535f9193793297",
          "name": "START_INVESTIGATION_REFERAL_REATTENDANCE",
          "active": false,
          "displayName": "Can start investigation referal reattendance",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "REGISTRATION",
      "permissions": [
        {
          "uid": "0e4ade153d8711ed8a533b465e8a84bd",
          "name": "CREATE_CLIENT",
          "active": false,
          "displayName": "Can create client",
          "__typename": "Permission"
        },
        {
          "uid": "0e4b53473d8711ed8a531fd41df9aecc",
          "name": "DELETE_CLIENT",
          "active": false,
          "displayName": "Can delete client",
          "__typename": "Permission"
        },
        {
          "uid": "0e4ba1693d8711ed8a53e380a3ccde33",
          "name": "VIEW_CLIENTS",
          "active": false,
          "displayName": "Can view clients",
          "__typename": "Permission"
        },
        {
          "uid": "0e4bef8b3d8711ed8a53ffd2ec3aac2e",
          "name": "EDIT_CLIENT",
          "active": false,
          "displayName": "Can edit client",
          "__typename": "Permission"
        },
        {
          "uid": "0e4c64bd3d8711ed8a53f3d723f933be",
          "name": "VIEW_SOLDIER_DETAILS",
          "active": false,
          "displayName": "Can view soldier details",
          "__typename": "Permission"
        },
        {
          "uid": "0e4cb2df3d8711ed8a539bbc891c6a69",
          "name": "CREATE_CLIENT_IDENTIFICATION",
          "active": false,
          "displayName": "Can create client identification",
          "__typename": "Permission"
        },
        {
          "uid": "0e4d27113d8711ed8a536165b7f6b98e",
          "name": "DELETE_CLIENT_IDENTIFICATION",
          "active": false,
          "displayName": "Can delete client identification",
          "__typename": "Permission"
        },
        {
          "uid": "0e4d75333d8711ed8a5359f612502102",
          "name": "EDIT_CLIENT_IDENTIFICATION",
          "active": false,
          "displayName": "Can edit client identification",
          "__typename": "Permission"
        },
        {
          "uid": "0e4dc3553d8711ed8a53755119902213",
          "name": "VIEW_CLIENT_IDENTIFICATIONS",
          "active": false,
          "displayName": "Can view client identifications",
          "__typename": "Permission"
        },
        {
          "uid": "0e4e38873d8711ed8a5313492a05042b",
          "name": "FIND_IDENTITY_AND_IDENTITY_NUMBER",
          "active": false,
          "displayName": "Can find identity and identity number",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "SHARED",
      "permissions": [
        {
          "uid": "0e4e86a93d8711ed8a5373bbb180e61d",
          "name": "CREATE_DEPARTMENT",
          "active": false,
          "displayName": "Can create department",
          "__typename": "Permission"
        },
        {
          "uid": "0e4ed4cb3d8711ed8a53e7f3d1da9330",
          "name": "VIEW_DEPARTMENTS",
          "active": false,
          "displayName": "Can view departments",
          "__typename": "Permission"
        },
        {
          "uid": "0e4f49fd3d8711ed8a53192e7ba31637",
          "name": "DELETE_DEPARTMENTS",
          "active": false,
          "displayName": "Can delete departments",
          "__typename": "Permission"
        },
        {
          "uid": "0e4f981f3d8711ed8a538356ca07a952",
          "name": "VIEW_DOSAGES",
          "active": false,
          "displayName": "Can view dosages",
          "__typename": "Permission"
        },
        {
          "uid": "0e500d513d8711ed8a535f98437d33e4",
          "name": "CREATE_FACILITY_DEPARTMENT",
          "active": false,
          "displayName": "Can create facility department",
          "__typename": "Permission"
        },
        {
          "uid": "0e505b733d8711ed8a532f86e82728e2",
          "name": "DELETE_FACILITY_DEPARTMENT",
          "active": false,
          "displayName": "Can delete facility department",
          "__typename": "Permission"
        },
        {
          "uid": "0e50f7b53d8711ed8a538d83d744a504",
          "name": "VIEW_FACILITY_DEPARTMENTS",
          "active": false,
          "displayName": "Can view facility departments",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "SOCIAL",
      "permissions": [
        {
          "uid": "0e5145d73d8711ed8a535b6d9177c640",
          "name": "VIEW_EXEMPTION_ACCESSES",
          "active": false,
          "displayName": "Can view exemption accesses",
          "__typename": "Permission"
        },
        {
          "uid": "0e51bb093d8711ed8a5387584179fd3d",
          "name": "CREATE_EXEMPTION_ACCESS",
          "active": false,
          "displayName": "Can create exemption access",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "THEATRE",
      "permissions": [
        {
          "uid": "0e52092b3d8711ed8a53bdeb3bdb9a67",
          "name": "CREATE_CONSENT_FORM",
          "active": false,
          "displayName": "Can create consent form",
          "__typename": "Permission"
        },
        {
          "uid": "0e527e5d3d8711ed8a539bbfa3637fd0",
          "name": "VIEW_CONSENT_FORMS",
          "active": false,
          "displayName": "Can view consent forms",
          "__typename": "Permission"
        },
        {
          "uid": "0e52cc7f3d8711ed8a53cdeabcd330f5",
          "name": "CREATE_OPERATION_FACILITY_ITEM",
          "active": false,
          "displayName": "Can create operation facility item",
          "__typename": "Permission"
        },
        {
          "uid": "0e5341b13d8711ed8a5379e28562e8ee",
          "name": "VIEW_OPERATION_FACILITY_ITEMS",
          "active": false,
          "displayName": "Can view operation facility items",
          "__typename": "Permission"
        },
        {
          "uid": "0e538fd33d8711ed8a53ddf7af69b1aa",
          "name": "DELETE_OPERATION_FACILITY_ITEM",
          "active": false,
          "displayName": "Can delete operation facility item",
          "__typename": "Permission"
        },
        {
          "uid": "0e5405053d8711ed8a5347fe01756c12",
          "name": "CREATE_PROCEDURE_CHECKLIST_ITEMS",
          "active": false,
          "displayName": "Can create procedure checklist items",
          "__typename": "Permission"
        },
        {
          "uid": "0e5453273d8711ed8a53197cf5cfcb01",
          "name": "CONFIRM_PROCEDURE_CHECKLIST",
          "active": false,
          "displayName": "Can confirm procedure checklist",
          "__typename": "Permission"
        },
        {
          "uid": "0e54c8593d8711ed8a53cd4e409fa0c6",
          "name": "CREATE_POST_ANAESTHETIC_SETTING",
          "active": false,
          "displayName": "Can create post anaesthetic setting",
          "__typename": "Permission"
        },
        {
          "uid": "0e55167b3d8711ed8a53236f38e921a2",
          "name": "VIEW_POST_ANAESTHETIC_SETTING",
          "active": false,
          "displayName": "Can view post anaesthetic setting",
          "__typename": "Permission"
        },
        {
          "uid": "0e55649d3d8711ed8a53e5d4937883e7",
          "name": "DELETE_POST_ANAESTHETIC_SETTING",
          "active": false,
          "displayName": "Can delete post anaesthetic setting",
          "__typename": "Permission"
        },
        {
          "uid": "0e55b2bf3d8711ed8a5361257191b2f9",
          "name": "CREATE_PROCEDURE_POST_ANAESTHETIC",
          "active": false,
          "displayName": "Can create procedure post anaesthetic",
          "__typename": "Permission"
        },
        {
          "uid": "0e5627f13d8711ed8a531ffc47acf6ed",
          "name": "VIEW_PROCEDURE_POST_ANAESTHETIC",
          "active": false,
          "displayName": "Can view procedure post anaesthetic",
          "__typename": "Permission"
        },
        {
          "uid": "0e5676133d8711ed8a538f3dc50585d9",
          "name": "CREATE_PRE_OPERATIONAL_CONDITION",
          "active": false,
          "displayName": "Can create pre operational condition",
          "__typename": "Permission"
        },
        {
          "uid": "0e56c4353d8711ed8a53955c0952de2d",
          "name": "VIEW_PRE_OPERATIONAL_CONDITIONS",
          "active": false,
          "displayName": "Can view pre operational conditions",
          "__typename": "Permission"
        },
        {
          "uid": "0e5739673d8711ed8a532b34b0f382b7",
          "name": "CREATE_PROCEDURE",
          "active": false,
          "displayName": "Can create procedure",
          "__typename": "Permission"
        },
        {
          "uid": "0e5787893d8711ed8a5369da93d9b2a9",
          "name": "EDIT_PROCEDURE",
          "active": false,
          "displayName": "Can edit procedure",
          "__typename": "Permission"
        },
        {
          "uid": "0e57d5ab3d8711ed8a53a72b8f35dd6c",
          "name": "VIEW_PROCEDURES",
          "active": false,
          "displayName": "Can view procedures",
          "__typename": "Permission"
        },
        {
          "uid": "0e584add3d8711ed8a531b0575a9eb09",
          "name": "CREATE_PROCEDURE_HISTORIES",
          "active": false,
          "displayName": "Can create procedure histories",
          "__typename": "Permission"
        },
        {
          "uid": "0e5898ff3d8711ed8a5357d3d604620d",
          "name": "CREATE_THEATRE",
          "active": false,
          "displayName": "Can create theatre",
          "__typename": "Permission"
        },
        {
          "uid": "0e58e7213d8711ed8a53dd8a42251597",
          "name": "VIEW_THEATRES",
          "active": false,
          "displayName": "Can view theatres",
          "__typename": "Permission"
        },
        {
          "uid": "0e595c533d8711ed8a53edc93bddeedd",
          "name": "DELETE_THEATRE",
          "active": false,
          "displayName": "Can delete theatre",
          "__typename": "Permission"
        },
        {
          "uid": "0e59aa753d8711ed8a53377ad67d2514",
          "name": "VIEW_THEATRE_FACILITY_ITEMS",
          "active": false,
          "displayName": "Can view theatre facility items",
          "__typename": "Permission"
        },
        {
          "uid": "0e59f8973d8711ed8a53a1892f1b4dd8",
          "name": "CREATE_THEATRE_FACILITY_ITEMS",
          "active": false,
          "displayName": "Can create theatre facility items",
          "__typename": "Permission"
        },
        {
          "uid": "0e5a6dca3d8711ed8a535776d932dc7b",
          "name": "CREATE_USER_THEATRE",
          "active": false,
          "displayName": "Can create user theatre",
          "__typename": "Permission"
        },
        {
          "uid": "0e5ae2fc3d8711ed8a53dd64ea9e6220",
          "name": "VIEW_ASSIGNED_THEATRES",
          "active": false,
          "displayName": "Can view assigned theatres",
          "__typename": "Permission"
        },
        {
          "uid": "0e5b311e3d8711ed8a53530e3f7814e6",
          "name": "VIEW_THEATRES_USERS",
          "active": false,
          "displayName": "Can view theatres users",
          "__typename": "Permission"
        },
        {
          "uid": "0e5b7f403d8711ed8a5321f42e0bbbb2",
          "name": "DELETE_THEATRE_USER",
          "active": false,
          "displayName": "Can delete theatre user",
          "__typename": "Permission"
        },
        {
          "uid": "0e5bcd623d8711ed8a5309c81b245a82",
          "name": "DELETE_THEATRE_FACILITY_ITEM",
          "active": false,
          "displayName": "Can delete theatre facility item",
          "__typename": "Permission"
        },
        {
          "uid": "5330ad9e5ab611edb3a41bc027e10d34",
          "name": "CREATE_SURGERY_TEAM",
          "active": false,
          "displayName": "Can create surgery team",
          "__typename": "Permission"
        },
        {
          "uid": "535c9fa05ab611edb3a4a32ae6818f50",
          "name": "VIEW_SURGERY_TEAMS",
          "active": false,
          "displayName": "Can view surgery teams",
          "__typename": "Permission"
        },
        {
          "uid": "5387f5625ab611edb3a48b680099a009",
          "name": "DELETE_SURGERY_TEAM",
          "active": false,
          "displayName": "Can delete surgery team",
          "__typename": "Permission"
        },
        {
          "uid": "548b5baa5ab611edb3a4cf5d476c5a7c",
          "name": "CREATE_QUESTION_ANSWERS",
          "active": false,
          "displayName": "Can create question answers",
          "__typename": "Permission"
        },
        {
          "uid": "54bc2fac5ab611edb3a4e92e1baab5ab",
          "name": "VIEW_QUESTION_ANSWERS",
          "active": false,
          "displayName": "Can view question answers",
          "__typename": "Permission"
        },
        {
          "uid": "77b51d66725811ed939a4f646b3fa679",
          "name": "CHANGE_THEATRE",
          "active": false,
          "displayName": "Can change theatre",
          "__typename": "Permission"
        },
        {
          "uid": "77bd5aea725811ed939a6f38ec957fe9",
          "name": "VIEW_CONSULT_ANAESTHESIA_LIST",
          "active": false,
          "displayName": "Can view consult anaesthesia list",
          "__typename": "Permission"
        },
        {
          "uid": "77bdd01c725811ed939a8b76ee00e8cc",
          "name": "VIEW_APPROVED_PROCEDURE",
          "active": false,
          "displayName": "Can view approved procedure",
          "__typename": "Permission"
        },
        {
          "uid": "77be454e725811ed939a71fc9f5bed63",
          "name": "VIEW_ADDED_TO_LIST_PROCEDURES",
          "active": false,
          "displayName": "Can view added to list procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77beba80725811ed939a33d80822115f",
          "name": "VIEW_STARTED_PROCEDURES",
          "active": false,
          "displayName": "Can view started procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77bf2fb2725811ed939af13ce76663a9",
          "name": "VIEW_SUBMITTED_PROCEDURES",
          "active": false,
          "displayName": "Can view submitted procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77bfa4e4725811ed939a95017ca61181",
          "name": "VIEW_DRAFT_PROCEDURES",
          "active": false,
          "displayName": "Can view draft procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77c01a16725811ed939ab14b49c8bc08",
          "name": "VIEW_RESCHEDULED_PROCEDURES",
          "active": false,
          "displayName": "Can view rescheduled procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77c08f48725811ed939ab116310c98fd",
          "name": "VIEW_ENDED_PROCEDURES",
          "active": false,
          "displayName": "Can view ended procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77c1047a725811ed939a51e10e7fb7e2",
          "name": "VIEW_REJECTED_PROCEDURES",
          "active": false,
          "displayName": "Can view rejected procedures",
          "__typename": "Permission"
        },
        {
          "uid": "77c1529c725811ed939a7fbdd07e6779",
          "name": "VIEW_CANCELLED_PROCEDURES",
          "active": false,
          "displayName": "Can view cancelled procedures",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "TREATMENT",
      "permissions": [
        {
          "uid": "0e5c42943d8711ed8a53839aae1dfaec",
          "name": "CREATE_CONSERVATIVE_MANAGEMENT",
          "active": false,
          "displayName": "Can create conservative management",
          "__typename": "Permission"
        },
        {
          "uid": "0e5c90b63d8711ed8a53f786e982dd06",
          "name": "VIEW_CONSERVATIVE_MANAGEMENT",
          "active": false,
          "displayName": "Can view conservative management",
          "__typename": "Permission"
        },
        {
          "uid": "0e5cded83d8711ed8a5347e506d499cd",
          "name": "CREATE_PRISCRIPTION",
          "active": false,
          "displayName": "Can create priscription",
          "__typename": "Permission"
        },
        {
          "uid": "0e5d540a3d8711ed8a5319dccd8d3c7c",
          "name": "CREATE_MEDICAL_SUPPLY",
          "active": false,
          "displayName": "Can create medical supply",
          "__typename": "Permission"
        },
        {
          "uid": "0e5da22c3d8711ed8a5317f3bfcce764",
          "name": "VIEW_DISPENSING_VERIFICATION_QUEUE",
          "active": false,
          "displayName": "Can view dispensing verification queue",
          "__typename": "Permission"
        },
        {
          "uid": "0e5df04e3d8711ed8a53c1d6eae01c6d",
          "name": "VIEW_VERIFICATION_ITEMS",
          "active": false,
          "displayName": "Can view verification items",
          "__typename": "Permission"
        },
        {
          "uid": "0e5e65803d8711ed8a5351244d07f307",
          "name": "VIEW_FACILITY_DISPENSING_QUEUE",
          "active": false,
          "displayName": "Can view facility dispensing queue",
          "__typename": "Permission"
        },
        {
          "uid": "0e5eb3a23d8711ed8a5305f622548e37",
          "name": "CREATE_VERIFIED_PRISCRIPTION_ITEMS",
          "active": false,
          "displayName": "Can create verified priscription items",
          "__typename": "Permission"
        },
        {
          "uid": "0e5f01c43d8711ed8a5389076f307bfa",
          "name": "CREATE_DISPENSED_ITEM",
          "active": false,
          "displayName": "Can create dispensed item",
          "__typename": "Permission"
        },
        {
          "uid": "0e5f4fe63d8711ed8a53d7f2e437e2ad",
          "name": "VIEW_PRESCRIPTIONS",
          "active": false,
          "displayName": "Can view prescriptions",
          "__typename": "Permission"
        },
        {
          "uid": "0e5f9e083d8711ed8a530b4395be36b1",
          "name": "CREATE_TRIAGE",
          "active": false,
          "displayName": "Can create triage",
          "__typename": "Permission"
        },
        {
          "uid": "0e5fec2a3d8711ed8a53874edd9b8c7d",
          "name": "VIEW_TRIAGE",
          "active": false,
          "displayName": "Can view triage",
          "__typename": "Permission"
        },
        {
          "uid": "0e60615c3d8711ed8a53abe056ec4edb",
          "name": "DELETE_TRIAGES",
          "active": false,
          "displayName": "Can delete triages",
          "__typename": "Permission"
        },
        {
          "uid": "0e60af7e3d8711ed8a5313606d04925a",
          "name": "CREATE_VITAL_SIGN",
          "active": false,
          "displayName": "Can create vital sign",
          "__typename": "Permission"
        },
        {
          "uid": "0e60fda03d8711ed8a533f48f830d484",
          "name": "VIEW_VITAL_SIGNS",
          "active": false,
          "displayName": "Can view vital signs",
          "__typename": "Permission"
        },
        {
          "uid": "0e614bc23d8711ed8a53b323a447f20b",
          "name": "DELETE_VITAL_SIGN",
          "active": false,
          "displayName": "Can delete vital sign",
          "__typename": "Permission"
        },
        {
          "uid": "50de320a5ab611edb3a47fa8bba853a8",
          "name": "CHANGE_DISPENSING_PHARMARCY",
          "active": false,
          "displayName": "Can change dispensing pharmarcy",
          "__typename": "Permission"
        },
        {
          "uid": "527f10d85ab611edb3a459b7f987b8bb",
          "name": "CREATE_NURSE_PRESCRIPTION_RECORD",
          "active": false,
          "displayName": "Can create nurse prescription record",
          "__typename": "Permission"
        },
        {
          "uid": "52bae15a5ab611edb3a4eb1116043b29",
          "name": "VIEW_NURSE_PRESCRIPTION_RECORDs",
          "active": false,
          "displayName": "Can view nurse prescription records",
          "__typename": "Permission"
        },
        {
          "uid": "52f6b1dc5ab611edb3a4ebe22f19bb73",
          "name": "CONFIRM_RECEIVING_PATIENT_MEDICATION",
          "active": false,
          "displayName": "Can confirm receiving patient medication",
          "__typename": "Permission"
        },
        {
          "uid": "53c80ba45ab611edb3a431b50f13602d",
          "name": "STOP_MEDICATION_USE",
          "active": false,
          "displayName": "Can stop medication use",
          "__typename": "Permission"
        },
        {
          "uid": "5410ad665ab611edb3a40130eaf7bbce",
          "name": "VIEW_PATIENT_MEDICATION_USE",
          "active": false,
          "displayName": "Can view patient medication use",
          "__typename": "Permission"
        },
        {
          "uid": "5450c3a85ab611edb3a4270f668d7fa0",
          "name": "CREATE_PATIENT_MEDICATION_USAGE",
          "active": false,
          "displayName": "Can create patient medication usage",
          "__typename": "Permission"
        },
        {
          "uid": "54e821ae5ab611edb3a47510bfc71cb9",
          "name": "RETURN_PATIENT_MEDICATION_TO_STORE",
          "active": false,
          "displayName": "Can return patient medication to store",
          "__typename": "Permission"
        },
        {
          "uid": "77acdfe6725811ed939a8718c78913e0",
          "name": "CHANGE_PATIENT_MEDICATION",
          "active": false,
          "displayName": "Can change patient medication",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "VISIT",
      "permissions": [
        {
          "uid": "0e61c0f43d8711ed8a53ad9ee76fafcd",
          "name": "VIEW_VISIT",
          "active": false,
          "displayName": "Can view visit",
          "__typename": "Permission"
        },
        {
          "uid": "0e620f163d8711ed8a53517d00777e43",
          "name": "START_VISIT",
          "active": false,
          "displayName": "Can start visit",
          "__typename": "Permission"
        },
        {
          "uid": "0e6284483d8711ed8a5389fb0a0fce10",
          "name": "CHANGE_VISIT_CSG",
          "active": false,
          "displayName": "Can change visit csg",
          "__typename": "Permission"
        },
        {
          "uid": "0e62d26a3d8711ed8a53fbd1476addb8",
          "name": "END_VISIT",
          "active": false,
          "displayName": "Can end visit",
          "__typename": "Permission"
        },
        {
          "uid": "0e63208c3d8711ed8a53a52d0a32876c",
          "name": "EXTEND_VISIT",
          "active": false,
          "displayName": "Can extend visit",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "UAA",
      "permissions": [
        {
          "uid": "0e6395be3d8711ed8a537b0c5bf4cf4a",
          "name": "CREATE_USER",
          "active": false,
          "displayName": "Can create user",
          "__typename": "Permission"
        },
        {
          "uid": "0e63e3e03d8711ed8a53c7f1ec50317b",
          "name": "VIEW_USERS",
          "active": false,
          "displayName": "Can view users",
          "__typename": "Permission"
        },
        {
          "uid": "0e6432023d8711ed8a530996f34a6528",
          "name": "DELETE_USER",
          "active": false,
          "displayName": "Can delete user",
          "__typename": "Permission"
        },
        {
          "uid": "0e64a7343d8711ed8a53fd86079e1545",
          "name": "RESET_USER_PASSWORD",
          "active": false,
          "displayName": "Can reset user password",
          "__typename": "Permission"
        },
        {
          "uid": "0e64f5563d8711ed8a53f50c706e0730",
          "name": "ASSIGN_USER_ROLES",
          "active": false,
          "displayName": "Can assign user roles",
          "__typename": "Permission"
        },
        {
          "uid": "0e6543783d8711ed8a537bbe5b3182ab",
          "name": "VIEW_FACILITY_USERS",
          "active": false,
          "displayName": "Can view facility users",
          "__typename": "Permission"
        },
        {
          "uid": "0e65919a3d8711ed8a53c775056d8493",
          "name": "CREATE_ROLE",
          "active": false,
          "displayName": "Can create role",
          "__typename": "Permission"
        },
        {
          "uid": "0e6606cc3d8711ed8a53a323a63441a3",
          "name": "VIEW_ROLES",
          "active": false,
          "displayName": "Can view roles",
          "__typename": "Permission"
        },
        {
          "uid": "0e6654ee3d8711ed8a53151b00bfdcb2",
          "name": "DELETE_ROLES",
          "active": false,
          "displayName": "Can delete roles",
          "__typename": "Permission"
        },
        {
          "uid": "0e66a3103d8711ed8a5331fe884b4906",
          "name": "ASSIGN_PERMISSION_TO_ROLE",
          "active": false,
          "displayName": "Can assign permission to role",
          "__typename": "Permission"
        },
        {
          "uid": "551488e05ab611edb3a41353b935ee06",
          "name": "CREATE_PHYSICAL_COUNT_USER",
          "active": false,
          "displayName": "Can create physical count user",
          "__typename": "Permission"
        },
        {
          "uid": "554e0f725ab611edb3a417603f8256c6",
          "name": "VIEW_PHYSICAL_COUNT_USERS",
          "active": false,
          "displayName": "Can view physical count users",
          "__typename": "Permission"
        },
        {
          "uid": "557c4b645ab611edb3a43b273a08e441",
          "name": "DELETE_PHYSICAL_COUNT_USER",
          "active": false,
          "displayName": "Can delete physical count user",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "SETTINGS",
      "permissions": [
        {
          "uid": "bad42c423e3111ed841ded0c53802b63",
          "name": "CREATE_FACILITY",
          "active": false,
          "displayName": "Can create facility",
          "__typename": "Permission"
        },
        {
          "uid": "4f540f8e5ab611edb3a419eea2ae161e",
          "name": "DELETE_JOBCODE",
          "active": false,
          "displayName": "Can delete jobcode",
          "__typename": "Permission"
        },
        {
          "uid": "4fb961105ab611edb3a43d7f8c3b5ec7",
          "name": "CREATE_JOBCODE",
          "active": false,
          "displayName": "Can create jobcode",
          "__typename": "Permission"
        },
        {
          "uid": "4ff8db125ab611edb3a48f8139087dce",
          "name": "VIEW_JOBCODES",
          "active": false,
          "displayName": "Can view jobcodes",
          "__typename": "Permission"
        },
        {
          "uid": "50432a845ab611edb3a4398c72d0ff2d",
          "name": "DELETE_BRANCH",
          "active": false,
          "displayName": "Can delete branch",
          "__typename": "Permission"
        },
        {
          "uid": "507844465ab611edb3a4cf15cf76bcb5",
          "name": "CREATE_BRANCH",
          "active": false,
          "displayName": "Can create branch",
          "__typename": "Permission"
        },
        {
          "uid": "50a6a7485ab611edb3a4052d4137e095",
          "name": "VIEW_BRANCHS",
          "active": false,
          "displayName": "Can view branchs",
          "__typename": "Permission"
        },
        {
          "uid": "5124ff0c5ab611edb3a4b163ae545d02",
          "name": "DELETE_COST_CENTER",
          "active": false,
          "displayName": "Can delete cost center",
          "__typename": "Permission"
        },
        {
          "uid": "515eface5ab611edb3a4cd3543e1b491",
          "name": "CREATE_COST_CENTER",
          "active": false,
          "displayName": "Can create cost center",
          "__typename": "Permission"
        },
        {
          "uid": "519378505ab611edb3a483e4dd668f34",
          "name": "VIEW_COST_CENTERS",
          "active": false,
          "displayName": "Can view cost centers",
          "__typename": "Permission"
        },
        {
          "uid": "51d1b9d25ab611edb3a441085fb10588",
          "name": "CREATE_FORM",
          "active": false,
          "displayName": "Can create form",
          "__typename": "Permission"
        },
        {
          "uid": "52059b145ab611edb3a4355e142169d8",
          "name": "VIEW_FORM",
          "active": false,
          "displayName": "Can view form",
          "__typename": "Permission"
        },
        {
          "uid": "523361d65ab611edb3a4215371e01b10",
          "name": "DELETE_FORM",
          "active": false,
          "displayName": "Can delete form",
          "__typename": "Permission"
        },
        {
          "uid": "779c1702725811ed939aa122040cfbcb",
          "name": "VIEW_OTHER_FACILITY_GLOBAL_SETTING",
          "active": false,
          "displayName": "Can view other facility global setting",
          "__typename": "Permission"
        },
        {
          "uid": "77ac43a4725811ed939a79437b8f382a",
          "name": "CREATE_OTHER_FACILITY_GLOBAL_SETTING",
          "active": false,
          "displayName": "Can create other facility global setting",
          "__typename": "Permission"
        },
        {
          "uid": "5c08fa4d861911ed92c6218d3c0a9c65",
          "name": "VIEW_QUALIFICATION",
          "active": false,
          "displayName": "Can view qualification",
          "__typename": "Permission"
        },
        {
          "uid": "5c10e98f861911ed92c6c9bd7ee0d86c",
          "name": "DELETE_QUALIFICATION",
          "active": false,
          "displayName": "Can delete qualification",
          "__typename": "Permission"
        },
        {
          "uid": "3f9610358c1e11ed9521415a745dfdfe",
          "name": "CREATE_QUALIFICATION",
          "active": false,
          "displayName": "Can create qualification",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "REPORT",
      "permissions": [
        {
          "uid": "1718db7a40d511ed8c9c4154689ae475",
          "name": "VIEW_REPORT",
          "active": false,
          "displayName": "Can view report",
          "__typename": "Permission"
        },
        {
          "uid": "0839841e55ead11ed940e9dc58a2a9813",
          "name": "VIEW_FACILITY_USER_PERFORMANCE",
          "active": false,
          "displayName": "Can view facility user performance",
          "__typename": "Permission"
        },
        {
          "uid": "0ba54e31e60d111ed889265600aefbafe",
          "name": "VIEW_FACILITY_CLIENT_ATTENDANCE_SUMMARY",
          "active": false,
          "displayName": "Can view facility client attendance summary",
          "__typename": "Permission"
        },
        {
          "uid": "03bea7ea360d411ed8892cd45e31a0348",
          "name": "VIEW_FACILITY_MHIS_DEPARTMENTS_CLAIMS_SUMMARY",
          "active": false,
          "displayName": "Can view facility mhis departments claims summary",
          "__typename": "Permission"
        },
        {
          "uid": "0688a5c5460d211ed88928f17ccb06f16",
          "name": "VIEW_FACILITY_BILLS_STATUS_SUMMARY",
          "active": false,
          "displayName": "Can view facility bills status summary",
          "__typename": "Permission"
        },
        {
          "uid": "0d2b904b560d311ed88923d5e63a0a1a8",
          "name": "VIEW_FACILITY_MHIS_PATIENTS_CLAIMS_SUMMARY",
          "active": false,
          "displayName": "Can view facility mhis patients claims summary",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "COMPLAINT",
      "permissions": [
        {
          "uid": "77afc620725811ed939ac317f13860fd",
          "name": "VIEW_ALL_COMPLAINTS",
          "active": false,
          "displayName": "Can view all complaints",
          "__typename": "Permission"
        },
        {
          "uid": "77b03b52725811ed939a6d69b487152a",
          "name": "VIEW_FACILITY_COMPLAINTS",
          "active": false,
          "displayName": "Can view facility complaints",
          "__typename": "Permission"
        },
        {
          "uid": "77b0d794725811ed939ad3d927de455c",
          "name": "CREATE_COMPLAINT",
          "active": false,
          "displayName": "Can create complaint",
          "__typename": "Permission"
        },
        {
          "uid": "77b14cc6725811ed939ab92ab62890cb",
          "name": "VIEW_MY_REPORTED_COMPLAINTS",
          "active": false,
          "displayName": "Can view my reported complaints",
          "__typename": "Permission"
        },
        {
          "uid": "77b1c1f8725811ed939a7b4bb50b0811",
          "name": "VIEW_COMPLAINT_CONVERSATION",
          "active": false,
          "displayName": "Can view complaint conversation",
          "__typename": "Permission"
        },
        {
          "uid": "77b2372a725811ed939a654c008c050d",
          "name": "CREATE_COMPLAINT_CONVERSATION",
          "active": false,
          "displayName": "Can create complaint conversation",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "FACILITY",
      "permissions": [
        {
          "uid": "77b2ac5c725811ed939a097547172238",
          "name": "CREATE_FACILITY_CHILDREN",
          "active": false,
          "displayName": "Can create facility children",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "ITEM",
      "permissions": [
        {
          "uid": "77b3218e725811ed939ad96be13839fc",
          "name": "VIEW_APPOINTMENT_SETTINGS_ITEM",
          "active": false,
          "displayName": "Can view appointment settings item",
          "__typename": "Permission"
        },
        {
          "uid": "77b396c0725811ed939a7760210bf02f",
          "name": "CREATE_APPOINTNEMT_SETTING_ITEM",
          "active": false,
          "displayName": "Can create appointnemt setting item",
          "__typename": "Permission"
        },
        {
          "uid": "5c11ace2861911ed92c6a7d5bc2fb417",
          "name": "CREATE_NHIF_ITEM",
          "active": false,
          "displayName": "Can create nhif item",
          "__typename": "Permission"
        },
        {
          "uid": "5c124924861911ed92c6a38b9b3877b9",
          "name": "DELETE_NHIF_ITEM",
          "active": false,
          "displayName": "Can delete nhif item",
          "__typename": "Permission"
        },
        {
          "uid": "5c12be56861911ed92c6dbd2b5266ae9",
          "name": "VIEW_NHIF_ITEMS",
          "active": false,
          "displayName": "Can view nhif items",
          "__typename": "Permission"
        },
        {
          "uid": "b1030c02880e11ed9fe991f63caac8ef",
          "name": "VIEW_NHIF_SCHEMES",
          "active": false,
          "displayName": "Can view nhif schemes",
          "__typename": "Permission"
        },
        {
          "uid": "b12ed6f5880e11ed9fe96ffdb233b6db",
          "name": "CREATE_NHIF_ITEM_PRICE",
          "active": false,
          "displayName": "Can create nhif item price",
          "__typename": "Permission"
        },
        {
          "uid": "b154d587880e11ed9fe98f73c5887256",
          "name": "DELETE_NHIF_ITEM_PRICE",
          "active": false,
          "displayName": "Can delete nhif item price",
          "__typename": "Permission"
        },
        {
          "uid": "b17ad419880e11ed9fe94748d2d299c9",
          "name": "VIEW_NHIF_ITEM_PRICES",
          "active": false,
          "displayName": "Can view nhif item prices",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "SERVING",
      "permissions": [
        {
          "uid": "77b43302725811ed939aeb74842ef777",
          "name": "VIEW_SERVINGS",
          "active": false,
          "displayName": "Can view servings",
          "__typename": "Permission"
        },
        {
          "uid": "77b4a834725811ed939a1b760e9d79a9",
          "name": "VIEW_VISIT_SERVING",
          "active": false,
          "displayName": "Can view visit serving",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "MODULE",
      "permissions": [
        {
          "uid": "77b607ca725811ed939af72fb4dde63a",
          "name": "ACCESS_LABORATORY",
          "active": false,
          "displayName": "Can access laboratory",
          "__typename": "Permission"
        },
        {
          "uid": "77b67cfc725811ed939a23335c65be5b",
          "name": "ACCESS_RADIOLOGY",
          "active": false,
          "displayName": "Can access radiology",
          "__typename": "Permission"
        },
        {
          "uid": "77b6f22e725811ed939a8de609bd53bf",
          "name": "ACCESS_MORTUARY",
          "active": false,
          "displayName": "Can access mortuary",
          "__typename": "Permission"
        },
        {
          "uid": "77b76760725811ed939a875654839c5b",
          "name": "ACCESS_THEATER",
          "active": false,
          "displayName": "Can access theater",
          "__typename": "Permission"
        },
        {
          "uid": "77b7dc92725811ed939af397e048ed64",
          "name": "ACCESS_FACILITY_MANAGEMENT",
          "active": false,
          "displayName": "Can access facility management",
          "__typename": "Permission"
        },
        {
          "uid": "77b851c4725811ed939a952abb2dc47f",
          "name": "ACCESS_SETTINGS",
          "active": false,
          "displayName": "Can access settings",
          "__typename": "Permission"
        },
        {
          "uid": "77b8c6f6725811ed939a19f6293b437d",
          "name": "ACCESS_REGISTRATION",
          "active": false,
          "displayName": "Can access registration",
          "__typename": "Permission"
        },
        {
          "uid": "77b93c28725811ed939acf57ea583ae9",
          "name": "ACCESS_BILLS",
          "active": false,
          "displayName": "Can access bills",
          "__typename": "Permission"
        },
        {
          "uid": "77b9b15a725811ed939a7572f7fe9194",
          "name": "ACCESS_NURSING_CARE",
          "active": false,
          "displayName": "Can access nursing care",
          "__typename": "Permission"
        },
        {
          "uid": "77ba268c725811ed939ab978de9c5835",
          "name": "ACCESS_PHARMACY",
          "active": false,
          "displayName": "Can access pharmacy",
          "__typename": "Permission"
        },
        {
          "uid": "77ba9bbe725811ed939aef00a9c8e63e",
          "name": "ACCESS_REPORT",
          "active": false,
          "displayName": "Can access report",
          "__typename": "Permission"
        },
        {
          "uid": "77bb10f0725811ed939aff4f8c6997be",
          "name": "ACCESS_SOCIAL_WELFARE",
          "active": false,
          "displayName": "Can access social welfare",
          "__typename": "Permission"
        },
        {
          "uid": "77bb8622725811ed939a656e9a6ddadc",
          "name": "ACCESS_USER_MANAGEMENT",
          "active": false,
          "displayName": "Can access user management",
          "__typename": "Permission"
        },
        {
          "uid": "77bbfb54725811ed939af768bdb81ef8",
          "name": "ACCESS_OPD",
          "active": false,
          "displayName": "Can access opd",
          "__typename": "Permission"
        },
        {
          "uid": "77bc7086725811ed939aa79ba967373a",
          "name": "ACCESS_IPD",
          "active": false,
          "displayName": "Can access ipd",
          "__typename": "Permission"
        },
        {
          "uid": "77bce5b8725811ed939a65ca02f10010",
          "name": "ACCESS_SPECIAL_CLINICS",
          "active": false,
          "displayName": "Can access special clinics",
          "__typename": "Permission"
        },
        {
          "uid": "62d59fb2867b11eda1303f907a770269",
          "name": "ACCESS_STORE",
          "active": false,
          "displayName": "Can access store",
          "__typename": "Permission"
        },
        {
          "uid": "e992e44cc11711edb51537745031807a",
          "name": "ACCESS_EMERGENCY",
          "active": false,
          "displayName": "Can access emergency",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    },
    {
      "groupName": "CLAIM",
      "permissions": [
        {
          "uid": "18bf8f1d8ff511ed8d7edbf96c37f265",
          "name": "CREATE_CLAIM",
          "active": false,
          "displayName": "Can create claim",
          "__typename": "Permission"
        },
        {
          "uid": "c65f0f3790f111edb644ff793ff5ed69",
          "name": "VIEW_CLAIMS",
          "active": false,
          "displayName": "Can view claims",
          "__typename": "Permission"
        }
      ],
      "__typename": "PermissionsDto"
    }
  ];

  createPermissionMatrix() {
    // Map the authorities to a Set for faster lookup
    Set<String> authoritiesList =
        Set.from(_authorities.map((item) => item["authority"]));

// Create the new list of permissions with the isAllowed flag

    for (var group in _permissionList) {
      List<Map<String, dynamic>> newPermissionListList = [];
      for (var permission in group["permissions"]) {
        var isAllowed = authoritiesList.contains(permission["name"]);
        var newPermission = Map<String, dynamic>.from(permission);
        newPermission["isAllowed"] = isAllowed;
        newPermissionListList.add(newPermission);
      }
      permissionList.add({
        "groupName": group["groupName"],
        "permission": newPermissionListList,
        "toggle": newPermissionListList
            .every((element) => element['isAllowed'] == true)
      });
    }
  }
}

class DataInstance {
  List<Map<String, dynamic>>? _dataList;
  set setData(List<Map<String, dynamic>> value) => _dataList = value;
  List<Map<String, dynamic>>? get getData => _dataList;
}

enum SwitchState { on, off, nothing }

class SwitchController extends ValueNotifier<SwitchState> {
  SwitchController(super.value);

  void toggle(SwitchState switchState) {
    value = switchState;
    notifyListeners();
  }
}

class ChangeDetectController extends ValueNotifier<bool> {
  ChangeDetectController(super.value);

  void check(bool changed) {
    value = changed;
    notifyListeners();
  }
}

class SelectedPermissions {
  final List<String> selectedPermissionUids = [];

  setAndRemovePermission(String permission) {
    if (selectedPermissionUids.contains(permission)) {
      selectedPermissionUids.remove(permission);
    } else {
      selectedPermissionUids.add(permission);
    }
    console('..........${selectedPermissionUids}');
  }
}
