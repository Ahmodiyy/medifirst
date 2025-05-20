import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy and Terms of Use'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Policy
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction\n'
                  'Welcome to MediFirst, a telemedicine platform committed to safeguarding your privacy. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our services. By accessing or using MediFirst, you agree to the practices described in this Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Personal Information Name, contact details, date of birth, gender, identification documents, and emergency contact details.\n'
                  '• Health Information Medical history, symptoms, prescriptions, diagnostic reports, treatment plans, and consultation records.\n'
                  '• Payment Information Billing details, transaction history, credit/debit card information, and insurance details where applicable.\n'
                  '• Technical Information IP address, device details, location data, operating system, browsing behavior, and other analytics-related data.\n'
                  '• Communication Records Messages, emails, calls, and interactions with our support team.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Provide telemedicine consultations and facilitate doctor-patient interactions.\n'
                  '• Maintain accurate and up-to-date medical records for continuity of care.\n'
                  '• Process payments and manage billing-related queries.\n'
                  '• Enhance platform functionality, diagnose technical issues, and improve user experience.\n'
                  '• Conduct research, statistical analysis, and health analytics while maintaining user anonymity.\n'
                  '• Ensure compliance with healthcare regulations and applicable legal requirements.\n'
                  '• Protect against fraud, unauthorized access, and security threats.\n'
                  '• Provide customer support and respond to inquiries effectively.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Sharing of Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We do not sell your personal information. However, we may share your information with:\n'
                  '• Healthcare Providers To facilitate medical consultations, treatment, and follow-ups.\n'
                  '• Payment Processors To securely process transactions and manage financial operations.\n'
                  '• Regulatory Authorities If required by law, court orders, or in response to legal proceedings.\n'
                  '• Technology Partners To enhance security, improve system performance, and integrate necessary features.\n'
                  '• Insurance Providers When applicable, to verify coverage and process claims.\n'
                  '• Business Transfers In case of a merger, acquisition, or sale of assets, user data may be transferred to the new entity.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We implement industry-standard security measures, including:\n'
                  '• Data encryption for secure storage and transmission.\n'
                  '• Multi-factor authentication and role-based access controls to prevent unauthorized access.\n'
                  '• Regular security audits and vulnerability assessments.\n'
                  '• Secure server infrastructure with firewalls and intrusion detection mechanisms.\n'
                  '• Secure data backup and disaster recovery protocols to protect against data loss.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Your Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'You have the right to:\n'
                  '• Access, update, or correct your personal data.\n'
                  '• Withdraw consent for data processing (subject to legal or contractual obligations).\n'
                  '• Request the deletion of your data where applicable.\n'
                  '• Restrict or object to certain data processing activities.\n'
                  '• Request a copy of your data in a portable format.\n'
                  '• File a complaint with relevant data protection authorities if you believe your rights have been violated.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Retention of Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We retain your data for as long as necessary to provide services and comply with legal obligations. Medical records are maintained in accordance with healthcare regulations and industry standards. If you close your account, we may retain some data to fulfill legal, regulatory, or security requirements.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '8. Cookies and Tracking Technologies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Our platform uses cookies, web beacons, and other tracking technologies to:\n'
                  '• Enhance user experience and personalize content.\n'
                  '• Analyze trends, monitor traffic, and improve service functionality.\n'
                  '• Recognize returning users and save preferences for a seamless experience.\n'
                  '• Support marketing and advertising efforts in compliance with applicable laws.\n'
                  'You may manage cookie preferences through your browser settings. However, disabling cookies may impact platform functionality.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '9. Third-Party Links',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst may contain links to third-party websites or services. We are not responsible for the privacy practices of these external sites. We encourage you to review the privacy policies of third-party platforms before sharing personal data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '10. Children\'s Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst is not intended for use by children under the age of 18 without parental or guardian consent. If we become aware that a minor has provided personal information without proper consent, we will take steps to delete such information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '11. International Data Transfers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'If you are accessing MediFirst from outside your country of residence, your information may be transferred and stored in a jurisdiction with different data protection laws. By using our services, you consent to such transfers in accordance with this Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '12. Updates to This Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may update this Privacy Policy periodically. Any changes will be posted with a revised effective date. We encourage users to review this policy regularly to stay informed about how we protect their data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '13. Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'For any questions, concerns, or requests regarding this Privacy Policy, please contact us at\n'
                  'MediFirst\n'
                  'medicinefirst.1@gmail.com\n'
                  '09011795914\n'
                  '24, Olutosin Ajayi Street, Ajao Estate, Lagos State.\n'
                  'By using MediFirst, you agree to the terms outlined in this Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Terms of Use for Patients
            Text(
              'Terms of Use for Patients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction\n'
                  'Welcome to MediFirst, a telemedicine platform designed to provide virtual healthcare services. By using MediFirst, you agree to comply with these Terms of Use. If you do not agree, please refrain from using our platform. These terms outline your rights, responsibilities, and limitations when using MediFirst.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Eligibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'To use MediFirst, you must be at least 18 years old or have parental/guardian consent if you are a minor. By accessing our services, you confirm that you meet these eligibility requirements. You also warrant that you are not prohibited from using MediFirst under any applicable laws.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Use of Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst provides remote healthcare consultations, medical advice, and prescription services. You agree to:\n'
                  '• Use the platform only for lawful medical consultations.\n'
                  '• Provide accurate and complete personal and medical information.\n'
                  '• Follow healthcare provider recommendations.\n'
                  '• Not misuse, abuse, or disrupt the platform’s services.\n'
                  '• Not share your account credentials with others or permit unauthorized access to your account.\n'
                  '• Use MediFirst services in compliance with all applicable medical and data protection laws.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. No Emergency Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst is not a replacement for emergency medical care. If you are experiencing a medical emergency, please call emergency services or visit the nearest hospital immediately. Our platform does not provide crisis intervention or life-threatening condition management.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Privacy and Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your personal and medical data will be collected and processed according to our Privacy Policy. We implement security measures to protect your data, but you are responsible for safeguarding your login credentials. By using MediFirst, you consent to our data collection, storage, and processing practices.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Medical Disclaimers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• MediFirst does not guarantee diagnoses, treatments, or outcomes.\n'
                  '• Services are provided based on the information you provide; incorrect or incomplete information may impact the effectiveness of the consultation.\n'
                  '• Our platform does not replace in-person medical evaluations where necessary.\n'
                  '• Healthcare providers on MediFirst exercise independent medical judgment; MediFirst does not interfere with their decisions.\n'
                  '• MediFirst is not liable for any adverse health outcomes resulting from the use of its services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Fees and Payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• MediFirst may charge consultation fees, which will be disclosed before you proceed.\n'
                  '• Payments must be made through approved payment methods.\n'
                  '• Refund policies will be subject to MediFirst’s discretion and applicable laws.\n'
                  '• You are responsible for any additional charges imposed by your bank or payment provider.\n'
                  '• MediFirst may modify its pricing structure with prior notice.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '8. User Conduct',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'You agree not to:\n'
                  '• Engage in fraudulent or misleading activities.\n'
                  '• Impersonate another individual.\n'
                  '• Harass, abuse, or harm healthcare providers or staff.\n'
                  '• Use MediFirst for any illegal or unethical activities.\n'
                  '• Attempt to gain unauthorized access to our systems or data.\n'
                  '• Record or distribute consultations without explicit permission.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '9. Account Termination',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst reserves the right to suspend or terminate your account if you violate these Terms of Use or engage in any activity that jeopardizes the security or integrity of the platform. Upon termination, you may lose access to your medical history and consultation records, subject to legal retention requirements.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '10. Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• MediFirst is not responsible for technical failures, internet outages, or any service disruptions beyond our control.\n'
                  '• We do not assume liability for any harm resulting from reliance on telemedicine consultations.\n'
                  '• To the extent permitted by law, MediFirst shall not be held liable for indirect, incidental, or consequential damages.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '11. Changes to Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst may update these Terms of Use periodically. Continued use of our services after changes indicates your acceptance of the updated terms. We recommend reviewing these terms regularly to stay informed about your rights and obligations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '12. Governing Law and Dispute Resolution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'These Terms of Use shall be governed by the laws of the Federal Republic of Nigeria. Any disputes arising out of or relating to these terms shall be resolved through mediation or arbitration before resorting to legal proceedings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '13. Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'For inquiries or support, contact us at:\n'
                  'MediFirst\n'
                  'medicinefirst.1@gmail.com\n'
                  '09011795914\n'
                  '24, Olutosin Ajayi Street, Ajao Estate, Lagos State.\n'
                  'By using MediFirst, you acknowledge that you have read, understood, and agreed to these Terms of Use.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Terms of Use for Medical Practitioners
            Text(
              'Terms of Use for Medical Practitioners',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction\n'
                  'Welcome to MediFirst, a telemedicine platform that connects healthcare professionals with patients for virtual consultations. By using MediFirst as a medical practitioner, you agree to comply with these Terms of Use. If you do not agree, please refrain from using our platform. These terms outline your rights, responsibilities, and limitations when providing telemedicine services through MediFirst.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Eligibility and Licensing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'To register as a medical practitioner on MediFirst, you must:\n'
                  '• Hold a valid and active medical license in your jurisdiction.\n'
                  '• Provide accurate, verifiable credentials and certifications.\n'
                  '• Maintain professional liability insurance where required by law.\n'
                  '• Adhere to all local, national, and international healthcare regulations governing telemedicine.\n'
                  'MediFirst reserves the right to verify your credentials and suspend or terminate accounts that fail to meet regulatory requirements.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Use of Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'By using MediFirst, you agree to:\n'
                  '• Provide ethical, professional, and evidence-based medical consultations.\n'
                  '• Keep patient interactions confidential and comply with applicable data protection laws.\n'
                  '• Accurately document all consultations and maintain proper medical records.\n'
                  '• Prescribe medications responsibly, following applicable telemedicine regulations.\n'
                  '• Refrain from engaging in fraudulent, misleading, or unethical activities.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. No Emergency or Critical Care Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst is not a substitute for emergency medical services. You must advise patients experiencing medical emergencies to seek immediate in-person care and contact emergency services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Privacy, Confidentiality, and Data Protection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'As a healthcare provider, you are responsible for safeguarding patient data. You agree to:\n'
                  '• Comply with relevant privacy laws (e.g., HIPAA, GDPR) when handling patient data.\n'
                  '• Maintain confidentiality of patient health information and records.\n'
                  '• Not share or disclose patient data without explicit consent, except as required by law.\n'
                  'MediFirst implements industry-standard security measures, but you are responsible for taking necessary precautions to protect your account and prevent unauthorized access.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Medical Responsibilities and Disclaimers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• You acknowledge that you are solely responsible for the medical advice and treatment provided to patients.\n'
                  '• MediFirst does not interfere with your medical judgment but reserves the right to investigate complaints regarding professional conduct.\n'
                  '• You must ensure that your telemedicine consultations comply with best medical practices and legal requirements.\n'
                  '• MediFirst is not responsible for any malpractice claims or legal disputes arising from your consultations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Fees, Payments, and Revenue Sharing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• MediFirst may charge a platform fee or commission for each consultation.\n'
                  '• Payouts for services rendered will be processed as per MediFirst’s payment schedule.\n'
                  '• You agree to set consultation fees within the platform’s guidelines and comply with refund policies where applicable.\n'
                  '• You are responsible for reporting and paying applicable taxes on your earnings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '8. Professional Conduct and User Interactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'You agree to:\n'
                  '• Treat patients with professionalism, respect, and ethical integrity.\n'
                  '• Avoid discrimination, harassment, or inappropriate behavior in any form.\n'
                  '• Follow telemedicine best practices and provide accurate medical advice.\n'
                  '• Report any unethical or illegal activity encountered on the platform.\n'
                  'MediFirst reserves the right to investigate and take appropriate action, including suspension or termination, in cases of misconduct.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '9. Account Suspension and Termination',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst may suspend or terminate your account if you:\n'
                  '• Provide false or misleading credentials.\n'
                  '• Violate medical or data protection laws.\n'
                  '• Engage in misconduct, fraud, or unethical practices.\n'
                  '• Fail to adhere to MediFirst’s guidelines and professional standards.\n'
                  'Termination may result in loss of access to patient records and pending payments, subject to regulatory and contractual obligations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '10. Liability and Indemnification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• MediFirst is not liable for any medical malpractice, negligence claims, or legal disputes arising from your practice.\n'
                  '• You agree to indemnify and hold MediFirst harmless from any claims, damages, or liabilities related to your consultations.\n'
                  '• MediFirst is not responsible for platform downtimes, technical failures, or external disruptions beyond our control.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '11. Changes to Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'MediFirst may update these Terms of Use periodically. Continued use of our services after changes indicates your acceptance of the updated terms. You are encouraged to review these terms regularly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '12. Governing Law and Dispute Resolution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'These Terms of Use shall be governed by the laws of the Federal Republic of Nigeria. Any disputes arising out of or relating to these terms shall be resolved through mediation or arbitration before resorting to legal proceedings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '13. Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'For inquiries or support, contact us at:\n'
                  'MediFirst\n'
                  'medicinefirst.1@gmail.com\n'
                  '09011795914\n'
                  '24, Olutosin Ajayi Street, Ajao Estate, Lagos State.\n'
                  'By using MediFirst as a medical practitioner, you acknowledge that you have read, understood, and agreed to these Terms of Use.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}