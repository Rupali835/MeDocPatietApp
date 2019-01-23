//
//  FAQData.swift
//  MedocPatient
//
//  Created by iAM on 17/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation

extension FAQViewController {
    func data() {
        let Q1 = FAQDataModal(question: "Q1: Will a person with Type 2 diabetes under control end up with the need for insulin?", answer: "A: As you may have read, Type 2 diabetes is a progressive disease. Will you require insulin? That all depends on individual factors that includes, among many other factors, weight, exercise, genetics, hormones and beta-cells, those cells that produce insulin in your pancreas. Research shows that managing your diabetes early in the disease process can have big payoffs in later years. Joining a support group for people with diabetes can be helpful in keeping you going in your health quest. Following up with your health care team regularly and keeping abreast on the new developments in diabetes management can also benefit you.\n\n Answered by Andrea Dunn, RD, LD, CDE: Andrea Dunn is a registered dietitian and certified diabetes educator with the Center for Human Nutrition.")
        faq.append(Q1)
        
        let Q2 = FAQDataModal(question: "Q2: Do calories from hard liquor add just as much caloric energy/fat as calories from other sources? What are 'empty calories' so many people refer to?", answer: "A: Excellent question. To make a long story short: A serving of alcohol is typically not very high in calories, BUT it is metabolized very differently than our food (90 percent in the liver), which can make weight loss tricky. For example, a light beer is roughly 100 calories and so is a handful of nuts. In terms of calories, this is not much at all, but in terms of metabolism, they vary significantly, partly because you have fiber, protein, and fat in the nut and virtually none of these in beer.\n 'This is why we can't say a calorie equals a calorie. Think of it this way, an empty calorie food or drink is something you can remove from the diet but still maintain optimal physiological function. Do our bodies need alcohol to survive? No. Candy? No. Soda? No. These are empty calories because they don't have a purpose. Do we need lean protein to survive? Yes. Fresh produce? Yes. You get the idea...\n\n Kylene Bogden, MS, RD, CSSD, LD: Ms. Bogden is a registered clinical dietitian who works in the Department of Nutrition Therapy at Cleveland Clinic.")
        faq.append(Q2)
        
        let Q3 = FAQDataModal(question: "Q3: Can a vegan diet cause lupus patient to go into remission?", answer: "A: The scientific evidence on the role of diet in autoimmune diseases such as lupus is just becoming available. I am a believer that a plant-based diet is helpful in promoting overall health and decreasing the chemicals that cause inflammation. I advocate a plant-based diet along with a very low-fat diet. You have to recall that French fries are vegan but they are not exactly healthy. I think that exercise and healthy diet are extremely important for everyone, but more so for those with autoimmune diseases.\n\n Answered by Howard_Smith,_MD: Dr. Smith is a rheumatologist in the Department of Rheumatic and Immunological Diseases specializing in lupus, arthritis and general rheumatology.")
        faq.append(Q3)
        
        let Q4 = FAQDataModal(question: "Q4: Is there a genetic factor to strokes?", answer: "A: Yes. There are genetic factors. There are some people that are born with certain genes that predispose them to stroke. One such condition would be CADASIL (cerebral autosomal-dominant arteriopathy with subcortical infarcts and leukoencephalopathy). If you are interested, I am sure you can learn more about this condition from the Web. Some people are born with genetic conditions that predispose them to clotting. This in turn may increase their stroke risk. Finally, if you have a strong family history of high blood pressure, diabetes, high cholesterol or any of the major modifiable risk factors for stroke, you may also be at higher risk because of this. However, these particular conditions are very much treatable and you certainly can do something about them to lower your risk.\n\n  Answered by Efrain Salgado, MD: Dr. Salgado is Director of the Cleveland Clinic Florida Stroke Center and Neurosonology Laboratory and Director of the Neurology Residency Training Program at Cleveland Clinic Florida.")
        faq.append(Q4)
        
        let Q5 = FAQDataModal(question: "Q5: What medications are best for the treatment of asthma? What are their side effects?", answer: "A: Albuterol is usually the primary 'rescue' or short-term medicine that is used to help acute asthma symptoms, such as coughing or wheezing. When a patient needs to use albuterol to relieve daytime symptoms more than twice per week, however, it usually reflects the need to use daily 'controller' or anti-inflammatory medications. Many people are concerned about possible side effects of inhaled steroids, which are the largest group of 'controller' medications available. When used in low- to medium-doses, however, inhaled steroids are very safe, even used on a daily basis for years. They are much safer than either multiple courses of oral steroids OR uncontrolled/undertreated asthma symptoms.\n\n Answered by John Carl, MD. Dr. Carl is a pediatric pulmonologist at Cleveland Clinic Children's who diagnoses and treats pneumonia, asthma, bronchitis, emphysema, and other respiratory problems in infants, children, and adolescents.")
        faq.append(Q5)
        
        let Q6 = FAQDataModal(question: "Q6: What exactly is a spine block injection? Will it work long-term for low back pain due to disc problems?", answer: "A: There are number of injections, and they basically are used to block the pain generators that are believed to be the cause of pain. These have been used for decades for pain control. Some need only one injection and some may need more than one to get adequate relief. There is no permanent solution that is consistent for these pain generators.\n\n Answered by Santhosh Thomas, DO. Dr. Thomas is board-certified in physical medicine and rehabilitation. His specialty interests include electromyography, evaluation and management of back and neck pain, interventional pain management, and sports medicine.")
        faq.append(Q6)
        
        let Q7 = FAQDataModal(question: "Q7: Can you recommend any tools that will help me stay motivated to stay on my eating plan?", answer: "A: These are a few that I have found quite helpful for my patients:\n 1: Continue to remind yourself of the benefits of reaching your goal. It may be looking good in those summer shorts or having more energy to keep up with your kids. Put up notes to remind yourself if necessary.\n 2: Weigh yourself weekly and give yourself a NON-FOOD reward. It doesn’t have to be expensive. It could be giving yourself a candle-lit bubble bath or a back-rub from your spouse. Get creative.\n 3: Continue to focus on health and wellness. Read books and articles that are motivating. Also, avoid environmental triggers that stir up your cravings such as watching food-related TV shows, meeting your friends at your favorite pastry shop, etc.\n 4: Keep graphic records of your accomplishments. Watching that line on your weight graph go down or the line on your exercise graph go up can be quite motivating!\n\n Answered by Maxine Smith, RD, LD. Ms. Smith has more than 20 years of experience as a registered, clinical dietitian and currently works in the department of Nutrition Therapy")
        faq.append(Q7)
        
        let Q8 = FAQDataModal(question: "Q8: Are there any long-term effects associated with taking ADHD (attention deficit hyperactivity disorder) medications? If so, what are they and what medications are implicated?", answer: "A: Many parents are concerned about the long-term effects of taking medicines. One of the best sources of information for this question is the Multimodal Treatment Study of ADHD (MTA). This study was a very large study of the treatments typically associated with ADHD, pharmacotherapy, behavioral intervention, and their combination. Evidence regarding the side effects of using stimulant treatment for ADHD shows that long-term use of medicine may decrease stature. However, in children who have continued use of medicine with generally higher doses of methylphenidate, stature differences remain relatively small. The use of stimulants to treat ADHD both in the short-term and long-term is considered safe by most of the major medical organizations, including the American Medical Association and the American Psychiatric Association.\n\n Answered by Michael Manos, PhD. Dr. Manos is the head of the Center for Pediatric Behavioral Health at Cleveland Clinic Children’s. He is the founding clinical and program director of the pediatric and adult ADHD Center for Evaluation and Treatment.")
        faq.append(Q8)
        
        let Q9 = FAQDataModal(question: "Q9: Can numerous fibroids and an enlarged uterus cause bladder prolapse? Why does my gynecologist think my bladder bulging into my vaginal canal is a fibroid even after I was sent to a urologist for stress incontinence issues?", answer: "A: Typically, uterine fibroids would not cause bladder prolapse. However, they can certainly make the symptoms and/or the degree of prolapse worse, depending upon the size and location of the fibroid. It is also possible that a fibroid in the right location could actually cause the front wall of the vagina—where the bladder is—to protrude. An ob/gyn can often figure this out with a pelvic examination, but sometimes an ultrasound or MRI is needed.\n\n Answered by Matthew D. Barber, MD, MHS. Dr. Barber is Professor of Surgery at the Cleveland Clinic Lerner College of Medicine at Case Western Reserve University and Vice-Chair of Clinical Research in the Ob/Gyn and Women's Health Institute.")
        faq.append(Q9)
        
        let Q10 = FAQDataModal(question: "Q10: My son is entering middle school in the fall. What advice can I give him if he finds himself on the receiving end of cyberbullying?", answer: "A: It is great that you're already thinking about what to do before he is even entering school. Parent and child discussions are key. Make sure he is comfortable in coming to you or a trusted adult, such as a teacher, if he is being bullied or feels threatened. Before he is permitted access to social media sites, such as Twitter or Facebook, know how to block inappropriate messages and behavior. You should know how to access blocking capabilities and have access to controls on his cell phone. If he does receive a threatening message, be sure he does not respond.\n\n Answered by Cheryl Cairns, CPNP. Ms. Cairns has been a registered nurse for more than 23 years and a pediatric nurse practitioner for 11 years. She provides preventive and chronic care, as well as urgent ill visits for children at Cleveland Clinic Children’s Hospital Community Pediatrics, Willoughby Hills.")
       // faq.append(Q10)
        
        let Q11 = FAQDataModal(question: "Q11: Which is better for covering up during a sunny day, light or dark clothes? Also, is there a danger from tanning sprays rather than tanning beds?", answer: "A: Light color clothing makes you feel cooler because it reflects most of the sun rays. However, dark colors actually absorb the sun rays and helps to prevent the ultraviolet (UV) radiation from getting to the skin underneath the clothing. Therefore, dark-colored clothes are more protective against the sun than light-colored clothing in areas that are covered, but are not protective for the skin that is not covered by the dark clothing. Sunscreen is still recommended for those uncovered areas.\n 'In terms of spray tans, there are not known harmful side effects to the skin from them. In terms of the skin, it is safe to use spray tanning. Certainly there are many known risks of tanning beds that we would recommend avoiding them entirely.'\n\n Answered by Missale Mesfin, MD. Dr. Mesfin is a is board certified dermatologist in the Department of Dermatology in Cleveland Clinic’s Dermatology & Plastic Surgery Institute.")
        faq.append(Q11)
        
        let Q12 = FAQDataModal(question: "Q12: Is breast cancer inherited?", answer: "A: Most women who get breast cancer do not have any family history of breast cancer. Just because a family member had breast cancer does not always mean that you will get breast cancer.\n 'We do know that there are some genes associated with a known increased risk of breast cancer. These are BRCA 1 (breast cancer 1, early onset human tumor suppressor gene) and BRCA 2 (breast cancer type 2, susceptibility protein). Only 10 percent of women with breast cancer have these inherited genes. These women usually get breast cancer at a young age and have multiple family members with breast or ovarian cancer.'\n\n Answered by Stephanie Valente, DO. Dr. Valente is a breast surgeon at Cleveland Clinic. She is a board certified general surgeon with fellowship training in surgical breast oncology and serves as the Associate Director of the Cleveland Clinic Breast Fellowship.")
        faq.append(Q12)
        
        let Q13 = FAQDataModal(question: "Q13: What causes Hashimoto's thyroiditis, and what is the best method of treatment? Can iodine help this condition?", answer: "A: Hashimoto's thyroiditis is a type of autoimmune thyroid disease in which the immune system attacks and changes the texture of the thyroid gland. Hashimoto's thyroiditis stops the gland from making enough thyroid hormones for the body to work the way it should. Therefore often people will need thyroid hormone replacement. Levothyroxine replacement (T4) is used to treat Hashimoto’s thyroiditis, although there are other formulations such as Armour thyroid (which contain both T3 and T4), which is also sometimes used.\n 'One should avoid taking iodine in this situation. If you have evidence of underactive thyroid and are symptomatic, the treatment of choice would be thyroid hormone replacement (T4 replacement).'\n\n Answered by Mary Vouyiouklis, MD. Dr. Vouyiouklis is an endocrinologist in the Department of Endocrinology, Diabetes and Metabolism in Cleveland Clinic’s Endocrinology & Metabolism Institute. She is board certified in internal medicine - endocrinology, diabetes, and metabolism.")
        faq.append(Q13)
        
        let Q14 = FAQDataModal(question: "Q14: Hearing aids are very expensive. How often will I have to be making an investment to replace or update them?", answer: "A: The typical life of hearing aids is usually about five to seven years. When you are first fitted with hearing aids, talk with your audiologist about choosing devices that will give you ‘room to grow’ in case your hearing loss progresses. Oftentimes, programming changes can be made to your current devices to accommodate changes in your hearing loss. Reasons that you may consider new hearing aids include:\n 1: Outliving the life of the hearing aids\n 2: New technologies develop that offer better listening opportunities with new features\n 3: Progression in your hearing loss beyond the capabilities of the hearing aids\n 4: These days technology advances more quickly than hearing aids stop working. Talk with your audiologist to determine if there are features or accessories that can be added to your existing devices or if newer hearing aids would be most beneficial for you.\n\n Answered by Sarah Sydlowski, AuD, PhD. Dr. Sydlowski is the audiology director of the Hearing Implant Program and a clinical audiologist for Cleveland Clinic’s Head & Neck Institute.")
        faq.append(Q14)
        
        let Q15 = FAQDataModal(question: "Q15: I am trying to eat a vegetarian diet. How can I get the protein that I need?", answer: "A: It is good that you are concerned because many people who start eating a vegetarian diet simply eliminate the meat from their diet and compromise their protein needs. Rich protein sources include lentils, legumes, nuts/seeds, soy products (such as tofu or soy meat substitutes), eggs, and dairy products. You need to be intentional about consuming these foods several times throughout the day.\n\n Answered by Maxine Smith, RD, LD. Ms. Smith has more than 20 years of experience as a registered, clinical dietitian and currently works in the department of Nutrition Therapy.")
        faq.append(Q15)
        
        let Q16 = FAQDataModal(question: "Q16: Can drinking water with lemon prevent kidney stones? Also, I have been told not to drink city water. What is the best water to drink?", answer: "A: One-half cup of lemon juice concentrate added to drinking water over the course of the day is a preventive therapy for calcium oxalate stone formation.\n 'As for city water, it is safe to drink but the concern is with water softened using a sodium ion exchange. Softened water should not be used for cooking, drinking, or for ice dispensers.'\n\n Answered by Maxine Smith RD, LD. Ms. Smith has more than 20 years of experience as a registered, clinical dietitian and currently works in the department of Nutrition Therapy.")
        faq.append(Q16)
        
        let Q17 = FAQDataModal(question: "Q17: When pain management doesn't help, what are other alternatives for back pain due to bulged discs and arthritis?", answer: "A: I usually advise people that options are nothing (leave it alone), exercise, medications, injections, surgery, or other (non-traditional like acupuncture, tai chi, or even cognitive behavioral therapy). Most people will do well with exercises and medication if needed. Surgery is usually done for so-called radicular or sciatic pains that don't get better with exercises, medications, or time. Injections may be considered for pain not relieved with time, exercise, or medication.\n\n Answered by Russell DeMicco, DO. Dr. DeMicco is a medical spine specialist with the Center for Spine Health. His specialty interests include the evaluation and management of back pain in adults and adolescents, non-operative spine care and musculoskeletal medicine, and interventional spine procedures.")
        faq.append(Q17)
        
        let Q18 = FAQDataModal(question: "Q18: Does day care, preschool, etc. have an effect on children developing allergies or asthma?", answer: "A: Yes, it does. Most children in day care or preschool settings experience more viral respiratory infections in the first two to three years of life than children who are at home with no siblings. If you control for genetic background and environmental triggers, however, the children who attended day care/preschool had a lower incidence of asthma later in life.\n\n  Answered by John Carl, MD. Dr. Carl is a pediatric pulmonologist at Cleveland Clinic Children's. He specializes in growth and development of the lung, airways, and respiratory function in children, and uses a variety of invasive and noninvasive diagnostic techniques on young patients.")
        faq.append(Q18)
        
        let Q19 = FAQDataModal(question: "Q19: I recently read that researchers believe certain foods might cure Alzheimer’s disease. Is this true? If so, which foods do this and how much would you have to consume to get the benefits?", answer: "A: Yes, there is research on this that is ongoing and potentially very exciting. There may be a link with inflammation and the buildup of amyloid plaque on the brain that increases the risk of Alzheimer’s disease. Diet may be a great way to help combat this. What should you eat? Plenty of fresh fruits and vegetables, 100% whole grains, extra virgin olive oil, nuts, and lean protein. As for the amount, I would say that eating three handfuls of vegetables per day and two handfuls of fruits twice a day is a great start. In addition, 1 to 2 tablespoons of extra virgin olive oil and two 3-ounce servings of fish, such as salmon, per week, would be wonderful. Good luck!\n\n Answered by Amy Jamieson-Petonic, MEd, RD. Ms. Jamieson-Petonic is the director of wellness coaching in the Cleveland Clinic Wellness Enterprise.")
        faq.append(Q19)
        
        let Q20 = FAQDataModal(question: "Q20: Is Greek yogurt healthier than regular yogurt?", answer: "A: Greek yogurt typically has more protein than regular yogurt (about 16 gm. versus 6 gm.), but it is not necessarily more healthy. No matter what type of yogurt you choose, look for one that is fat-free or at least low-fat and that is not loaded with sugar. Plain yogurt will obviously not have added sugar; and, typically, yogurts that are 100 calories or less for a 6 oz. container will be moderate in added sugar.\n\n Answered by Maxine Smith, RD, LD. Ms. Smith has more than 20 years of experience as a registered, clinical dietitian and currently works in the department of Nutrition Therapy.")
        faq.append(Q20)
    }
    
}
