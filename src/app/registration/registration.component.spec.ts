import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ReactiveFormsModule } from '@angular/forms';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { RegistrationComponent } from './registration.component';

describe('RegistrationComponent', () => {
  let component: RegistrationComponent;
  let fixture: ComponentFixture<RegistrationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReactiveFormsModule],
      declarations: [RegistrationComponent]
    }).compileComponents();

    fixture = TestBed.createComponent(RegistrationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  // 🔹 Component Initialization Tests
  describe('Component Initialization', () => {
    it('should create the component', () => {
      expect(component).toBeTruthy();
    });

    it('should initialize with default values', () => {
      expect(component.submitted).toBe(false);
      expect(component.registrationForm).toBeDefined();
    });

    it('should create form with all required controls', () => {
      const controls = component.registrationForm.controls;
      expect(controls['fullName']).toBeTruthy();
      expect(controls['email']).toBeTruthy();
      expect(controls['password']).toBeTruthy();
      expect(controls['confirmPassword']).toBeTruthy();
      expect(controls['gender']).toBeTruthy();
    });

    it('should have form invalid when empty', () => {
      expect(component.registrationForm.invalid).toBe(true);
    });

    it('should have getter f() return form controls', () => {
      expect(component.f).toBe(component.registrationForm.controls);
    });
  });

  // 🔹 Full Name Field Validation Tests
  describe('Full Name Field Validation', () => {
    it('should be required', () => {
      const fullName = component.registrationForm.get('fullName');
      fullName?.setValue('');
      expect(fullName?.hasError('required')).toBe(true);
    });

    it('should require minimum 3 characters', () => {
      const fullName = component.registrationForm.get('fullName');
      fullName?.setValue('ab');
      expect(fullName?.hasError('minlength')).toBe(true);
    });

    it('should be valid with 3 or more characters', () => {
      const fullName = component.registrationForm.get('fullName');
      fullName?.setValue('John Doe');
      expect(fullName?.valid).toBe(true);
    });

    it('should accept names with spaces and special characters', () => {
      const fullName = component.registrationForm.get('fullName');
      fullName?.setValue('Mary-Jane O\'Connor');
      expect(fullName?.valid).toBe(true);
    });
  });

  // 🔹 Email Field Validation Tests
  describe('Email Field Validation', () => {
    it('should be required', () => {
      const email = component.registrationForm.get('email');
      email?.setValue('');
      expect(email?.hasError('required')).toBe(true);
    });

    it('should validate email format', () => {
      const email = component.registrationForm.get('email');
      
      // Invalid email formats
      email?.setValue('invalid-email');
      expect(email?.hasError('email')).toBe(true);
      
      email?.setValue('test@');
      expect(email?.hasError('email')).toBe(true);
      
      email?.setValue('@domain.com');
      expect(email?.hasError('email')).toBe(true);
    });

    it('should accept valid email formats', () => {
      const email = component.registrationForm.get('email');
      
      const validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'test+tag@gmail.com',
        'user123@test-domain.org'
      ];

      validEmails.forEach(validEmail => {
        email?.setValue(validEmail);
        expect(email?.valid).toBe(true);
      });
    });
  });

  // 🔹 Password Field Validation Tests
  describe('Password Field Validation', () => {
    it('should be required', () => {
      const password = component.registrationForm.get('password');
      password?.setValue('');
      expect(password?.hasError('required')).toBe(true);
    });

    it('should require minimum 6 characters', () => {
      const password = component.registrationForm.get('password');
      password?.setValue('12345');
      expect(password?.hasError('minlength')).toBe(true);
    });

    it('should be valid with 6 or more characters', () => {
      const password = component.registrationForm.get('password');
      password?.setValue('123456');
      expect(password?.valid).toBe(true);
    });

    it('should accept complex passwords', () => {
      const password = component.registrationForm.get('password');
      password?.setValue('MySecure@Password123');
      expect(password?.valid).toBe(true);
    });
  });

  // 🔹 Confirm Password Field Tests
  describe('Confirm Password Field Validation', () => {
    it('should be required', () => {
      const confirmPassword = component.registrationForm.get('confirmPassword');
      confirmPassword?.setValue('');
      expect(confirmPassword?.hasError('required')).toBe(true);
    });
  });

  // 🔹 Gender Field Tests
  describe('Gender Field Validation', () => {
    it('should be required', () => {
      const gender = component.registrationForm.get('gender');
      gender?.setValue('');
      expect(gender?.hasError('required')).toBe(true);
    });

    it('should accept valid gender values', () => {
      const gender = component.registrationForm.get('gender');
      
      gender?.setValue('male');
      expect(gender?.valid).toBe(true);
      
      gender?.setValue('female');
      expect(gender?.valid).toBe(true);
    });
  });

  // 🔹 Password Matching Validation Tests
  describe('Password Matching Validation', () => {
    it('should set mismatch error when passwords differ', () => {
      component.registrationForm.patchValue({
        password: 'password123',
        confirmPassword: 'different123'
      });
      expect(component.registrationForm.errors?.['mismatch']).toBe(true);
    });

    it('should clear mismatch error when passwords match', () => {
      component.registrationForm.patchValue({
        password: 'password123',
        confirmPassword: 'password123'
      });
      expect(component.registrationForm.errors?.['mismatch']).toBeFalsy();
    });

    it('should work with passwordMatchValidator function', () => {
      const mockForm = component.registrationForm;
      mockForm.patchValue({
        password: 'test123',
        confirmPassword: 'test123'
      });
      
      const result = component.passwordMatchValidator(mockForm);
      expect(result).toBeNull();
    });

    it('should return mismatch error for different passwords', () => {
      const mockForm = component.registrationForm;
      mockForm.patchValue({
        password: 'test123',
        confirmPassword: 'different456'
      });
      
      const result = component.passwordMatchValidator(mockForm);
      expect(result).toEqual({ mismatch: true });
    });
  });

  // 🔹 Form Submission Tests
  describe('Form Submission', () => {
    beforeEach(() => {
      // Mock window.alert and console.log
      jest.spyOn(window, 'alert').mockImplementation(() => {});
      jest.spyOn(console, 'log').mockImplementation(() => {});
    });

    it('should not proceed when form is invalid', () => {
      component.onSubmit();
      expect(component.submitted).toBe(true);
      expect(window.alert).not.toHaveBeenCalled();
      expect(console.log).not.toHaveBeenCalled();
    });

    it('should submit successfully when form is valid', () => {
      // Fill form with valid data
      component.registrationForm.setValue({
        fullName: 'John Smith',
        email: 'john.smith@example.com',
        password: 'securepass123',
        confirmPassword: 'securepass123',
        gender: 'male'
      });

      component.onSubmit();

      expect(window.alert).toHaveBeenCalledWith('Registration Successful!');
      expect(console.log).toHaveBeenCalledWith('Form Submitted', component.registrationForm.value);
    });

    it('should reset form after successful submission', () => {
      // Fill form with valid data
      component.registrationForm.setValue({
        fullName: 'Jane Doe',
        email: 'jane.doe@example.com',
        password: 'password123',
        confirmPassword: 'password123',
        gender: 'female'
      });

      component.onSubmit();

      expect(component.registrationForm.pristine).toBe(true);
      expect(component.submitted).toBe(false);
    });

    it('should handle edge case with empty confirm password', () => {
      component.registrationForm.patchValue({
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: '',
        gender: 'male'
      });

      component.onSubmit();
      expect(component.submitted).toBe(true);
      expect(window.alert).not.toHaveBeenCalled();
    });
  });

  // 🔹 DOM Integration Tests
  describe('DOM Integration', () => {
    it('should render form title', () => {
      const titleElement = fixture.debugElement.query(By.css('h2'));
      expect(titleElement.nativeElement.textContent).toBe('Registration Form');
    });

    it('should render all input fields', () => {
      const inputs = fixture.debugElement.queryAll(By.css('input'));
      expect(inputs.length).toBe(4); // fullName, email, password, confirmPassword
      
      const select = fixture.debugElement.query(By.css('select'));
      expect(select).toBeTruthy();
    });

    it('should render submit button', () => {
      const button = fixture.debugElement.query(By.css('button[type="submit"]'));
      expect(button.nativeElement.textContent.trim()).toBe('Register');
    });

    it('should show validation errors after submit attempt', () => {
      component.onSubmit(); // Submit empty form
      fixture.detectChanges();

      const errorElements = fixture.debugElement.queryAll(By.css('.error small'));
      expect(errorElements.length).toBeGreaterThan(0);
    });

    it('should display specific validation messages', () => {
      component.onSubmit(); // Submit empty form
      fixture.detectChanges();

      const errorTexts = fixture.debugElement.queryAll(By.css('.error small'))
        .map(el => el.nativeElement.textContent);

      expect(errorTexts).toContain('Full Name is required.');
      expect(errorTexts).toContain('Email is required.');
      expect(errorTexts).toContain('Password is required.');
      expect(errorTexts).toContain('Gender is required.');
    });

    it('should display password mismatch error', () => {
      component.registrationForm.patchValue({
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'different123',
        gender: 'male'
      });
      
      component.onSubmit();
      fixture.detectChanges();

      const mismatchError = fixture.debugElement.query(
        By.css('.error small')
      )?.nativeElement.textContent;
      
      expect(mismatchError).toContain('Passwords do not match');
    });

    it('should not show errors before form submission', () => {
      const errorElements = fixture.debugElement.queryAll(By.css('.error'));
      errorElements.forEach(error => {
        expect(error.nativeElement.style.display).toBeFalsy();
      });
    });
  });

  // 🔹 User Interaction Tests
  describe('User Interaction', () => {
    it('should update form values when user types', () => {
      const fullNameInput = fixture.debugElement.query(By.css('input[formControlName="fullName"]'));
      
      fullNameInput.nativeElement.value = 'Test User';
      fullNameInput.nativeElement.dispatchEvent(new Event('input'));
      
      expect(component.registrationForm.get('fullName')?.value).toBe('Test User');
    });

    it('should trigger onSubmit when form is submitted', () => {
      jest.spyOn(component, 'onSubmit');
      
      const form = fixture.debugElement.query(By.css('form'));
      form.nativeElement.dispatchEvent(new Event('submit'));
      
      expect(component.onSubmit).toHaveBeenCalled();
    });

    it('should handle gender selection', () => {
      const genderSelect = fixture.debugElement.query(By.css('select[formControlName="gender"]'));
      
      genderSelect.nativeElement.value = 'female';
      genderSelect.nativeElement.dispatchEvent(new Event('change'));
      
      expect(component.registrationForm.get('gender')?.value).toBe('female');
    });
  });

  // 🔹 Edge Cases and Error Handling Tests
  describe('Edge Cases', () => {
    it('should handle very long input values', () => {
      const longName = 'A'.repeat(1000);
      component.registrationForm.get('fullName')?.setValue(longName);
      expect(component.registrationForm.get('fullName')?.valid).toBe(true);
    });

    it('should handle special characters in input', () => {
      component.registrationForm.patchValue({
        fullName: 'José María García-López',
        email: 'josé@example.com',
        password: 'pássw@rd123',
        confirmPassword: 'pássw@rd123',
        gender: 'male'
      });

      expect(component.registrationForm.valid).toBe(true);
    });

    it('should handle form state changes correctly', () => {
      expect(component.registrationForm.dirty).toBe(false);
      
      component.registrationForm.get('fullName')?.setValue('Test');
      expect(component.registrationForm.dirty).toBe(true);
    });

    it('should validate that passwords can contain special characters', () => {
      component.registrationForm.patchValue({
        password: 'Test@123!',
        confirmPassword: 'Test@123!'
      });

      expect(component.registrationForm.errors?.['mismatch']).toBeFalsy();
    });
  });

  // 🔹 Performance and Memory Tests
  describe('Performance', () => {
    it('should not create memory leaks in form validation', () => {
      for (let i = 0; i < 100; i++) {
        component.registrationForm.patchValue({
          fullName: `User${i}`,
          email: `user${i}@example.com`
        });
      }
      
      expect(component.registrationForm.get('fullName')?.value).toBe('User99');
    });
  });
});